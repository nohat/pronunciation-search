class Pronunciation < ActiveRecord::Base
  belongs_to :word

  def as_json(options)
    arpabet
  end

  def to_s
    "/#{arpabet}/"
  end

  def sounds
    @sounds ||= arpabet.split(/\s/).map do |symbol|
      vowel, stress_level = symbol.scan(/(..)(.)/).first
      vowel ? Phoneme.new(vowel, stress_level) : Phoneme.new(symbol)
    end
  end

  def syllables
    return syllables if @syllables
    parser = Parser.new sounds
    @syllables = parser.parse
  end

  def ipa
    ipa_string = ''
    is_first_syllable = true
    syllables.each do |syllable|
      ipa_string << (syllable.ipa_stress_symbol(is_first_syllable) + syllable.ipa)
      is_first_syllable = false
    end
    ipa_string
  end

  class Syllable
    attr_accessor :onset, :peak, :coda
    def initialize(onset=[], peak=nil, coda=[])
      @onset, @peak, @coda = onset, peak, coda
    end

    def ipa
      phonemes = onset + [peak] + coda
      phonemes.map { |phoneme| phoneme.ipa }.join
    end

    IPA_STRESS_SYMBOLS = { '0' => '.', '1' => "\u02C8", '2' => "\u02CC"}
    def ipa_stress_symbol(is_first_syllable = false)
      if is_first_syllable && peak.stress == '0'
        ''
      else
        IPA_STRESS_SYMBOLS[peak.stress]
      end
    end
  end

  class Parser
    attr_accessor :syllables, :current_syllable, :vowel, :consonant_queue
    def initialize(input)
      @input = input
      @syllables = []
      @consonant_queue = []
      @current_syllable = Pronunciation::Syllable.new
      super
    end
    state_machine :state, :initial => :initial_onset do
      event :get_consonant do
        transition [:vowel, :consonant] => :consonant
        transition :initial_onset => :initial_onset
      end
      event :get_vowel do
        transition [:vowel, :consonant, :initial_onset] => :vowel
      end
      event :finish do
        transition [:vowel, :consonant] => :finished
      end
      before_transition :initial_onset => :vowel do |pr|
        pr.current_syllable.onset = pr.consonant_queue
        pr.consonant_queue = []
        pr.current_syllable.peak = pr.vowel
      end
      before_transition [:vowel, :consonant] => :vowel do |pr|
        coda, onset = Parser.split_cluster(pr.consonant_queue)
        pr.consonant_queue = []
        pr.current_syllable.coda = coda
        pr.syllables.push pr.current_syllable
        pr.current_syllable = Pronunciation::Syllable.new(onset, pr.vowel)
      end
      before_transition all => :finished do |pr|
        pr.current_syllable.coda = pr.consonant_queue
        pr.syllables.push pr.current_syllable
      end
    end

    def get_vowel(sound)
      @vowel = sound
      super
    end

    def get_consonant(sound)
      @consonant_queue.push sound
      super
    end

    def parse
      @input.each do |sound|
        case sound.type
        when :vowel
          get_vowel(sound)
        when :consonant
          get_consonant(sound)
        end
      end
      finish
      syllables
    end

    def self.split_cluster(cluster)
      coda = cluster
      onset = []
      while POSSIBLE_ONSETS.include?([coda.last.try(:symbol)] + onset.map {|phoneme| phoneme.symbol}) do
        onset.unshift coda.pop
      end
      [coda, onset]
    end
  end

  class Phoneme
    attr_reader :type, :stress, :ipa, :symbol
    def initialize(symbol, stress=nil)
      @symbol = symbol
      @stress = stress
      data = PHONEME_TABLE[symbol]
      raise "No such phoneme #{symbol}" unless data
      @type = data[:type]
      if stress == '0' and data[:ipa_unstressed]
        @ipa = data[:ipa_unstressed]
      else
        @ipa = data[:ipa]
      end
    end

    def to_s
      "#{symbol}#{stress}"
    end

    PHONEME_TABLE = {
      'P'  => { :type => :consonant, :ipa => 'p' },
      'B'  => { :type => :consonant, :ipa => 'b' },
      'T'  => { :type => :consonant, :ipa => 't'  },
      'D'  => { :type => :consonant, :ipa => 'd' },
      'K'  => { :type => :consonant, :ipa => 'k'  },
      'G'  => { :type => :consonant, :ipa => 'g' },
      'CH' => { :type => :consonant, :ipa => "t\u0283"  },
      'JH' => { :type => :consonant, :ipa => "d\u0292" },
      'TH' => { :type => :consonant, :ipa => "\u03B8"  },
      'DH' => { :type => :consonant, :ipa => "\u00D0" },
      'F'  => { :type => :consonant, :ipa => 'f'  },
      'V'  => { :type => :consonant, :ipa => 'v' },
      'S'  => { :type => :consonant, :ipa => 's'  },
      'Z'  => { :type => :consonant, :ipa => 'z' },
      'SH' => { :type => :consonant, :ipa => "\u0283"  },
      'ZH' => { :type => :consonant, :ipa => "\u0292" },
      'HH' => { :type => :consonant, :ipa => 'h'  },
      'M'  => { :type => :consonant, :ipa => 'm' },
      'N'  => { :type => :consonant, :ipa => 'n' },
      'NG' => { :type => :consonant, :ipa => "\u014B" },
      'R'  => { :type => :consonant, :ipa => 'r' },
      'L'  => { :type => :consonant, :ipa => 'l' },
      'W'  => { :type => :consonant, :ipa => 'w' },
      'Y'  => { :type => :consonant, :ipa => 'j' },
      'AA' => { :type => :vowel, :ipa => "\u0251" },
      'AE' => { :type => :vowel, :ipa => "\u00E6" },
      'AH' => { :type => :vowel, :ipa => "\u028C", :ipa_unstressed => "\u0259" },
      'AO' => { :type => :vowel, :ipa => "\u0254" },
      'AW' => { :type => :vowel, :ipa => "a\u028A" },
      'AY' => { :type => :vowel, :ipa => "a\u026A" },
      'EH' => { :type => :vowel, :ipa => "\u025B" },
      'ER' => { :type => :vowel, :ipa => "\u025D", :ipa_unstressed => "\u025A" },
      'EY' => { :type => :vowel, :ipa => "e\u026A" },
      'IH' => { :type => :vowel, :ipa => "\u026A" },
      'IY' => { :type => :vowel, :ipa => 'i' },
      'OW' => { :type => :vowel, :ipa => "o\u028A" },
      'OY' => { :type => :vowel, :ipa => "\u0254\u026A" },
      'UH' => { :type => :vowel, :ipa => "\u028A" },
      'UW' => { :type => :vowel, :ipa => 'u' },
    }
  end

  POSSIBLE_ONSETS = [
    ['P'], ['B'], ['T'], ['D'], ['K'], ['G'],
    ['CH'], ['JH'],
    ['TH'], ['DH'], ['F'], ['V'], ['S'], ['Z'], ['SH'], ['ZH'], ['HH'],
    ['M'], ['N'], ['R'], ['L'], ['W'], ['Y'],
    %W[P L], %W[B L], %W[K L], %W[G L], %W[P R], %W[B R], %W[T R], %W[D R], %W[K R], %W[G R], %W[T W], %W[K W],
    %W[F L], %W[S L], %W[F R], %W[TH R], %W[SH R], %W[HH W], %W[S W],
    %W[P Y], %W[B Y], %W[T Y], %W[D Y], %W[K Y], %W[G Y], %W[M Y], %W[N Y], %W[F Y], %W[V Y], %W[TH Y], %W[S Y], %W[Z Y], %W[HH Y], %W[L Y],
    %W[S P], %W[S T], %W[S K],
    %W[S M], %W[S N],
    %W[S P R], %W[S T R], %W[S K R], %W[S M Y],
  ]

end