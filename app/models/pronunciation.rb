class Pronunciation < ActiveRecord::Base
  belongs_to :word

  def as_json(options)
    arpabet
  end

  def to_s
    "/#{arpabet}/"
  end

  def sounds
    @sounds ||= arpabet.split /\s/
  end

  def to_syllables
    syllables = self.class.to_syllable_data sounds
    syllables.map{|s| s[:onset] + [s[:peak]] + s[:coda]}
  end

  def ipa
    ipa = ''
    is_first_syllable = true
    self.class.to_syllables(sounds).each do |syllable|
      stress_symbol, ipa_string = self.class.syllable_to_ipa(syllable)
      if is_first_syllable
        is_first_syllable = false
        if stress_symbol == '.'
          stress_symbol = ''
        end
      end
      ipa << (stress_symbol + ipa_string)
    end
    ipa
  end

  def self.syllable_to_ipa(syllable)
    vowel, stress_level = syllable[:peak].scan(/(..)(.)/).first
    ipa_string = []
    ipa_string.push(* syllable[:onset].map{ |sound| to_ipa(sound)})
    ipa_string << to_ipa(vowel, stress_level == '0')
    ipa_string.push(* syllable[:coda].map{ |sound| to_ipa(sound)})
    [ipa_stress_symbol(stress_level), ipa_string.join]
  end

  class Parser
    def initialize(input)
      @input = input
      @syllables = []
      @consonant_queue = []
      @current_syllable = {}
      super
    end
    attr_accessor :syllables, :current_syllable, :vowel, :consonant_queue
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
        pr.current_syllable[:onset] = pr.consonant_queue
        pr.consonant_queue = []
        pr.current_syllable[:peak] = pr.vowel
      end
      before_transition [:vowel, :consonant] => :vowel do |pr|
        coda, onset = Pronunciation.split_cluster(pr.consonant_queue)
        pr.consonant_queue = []
        pr.current_syllable[:coda] = coda
        pr.syllables.push pr.current_syllable
        pr.current_syllable = {:onset => onset, :peak => pr.vowel}
      end
      before_transition all => :finished do |pr|
        pr.current_syllable[:coda] = pr.consonant_queue
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
        if (Pronunciation.type(sound)) == :vowel
          get_vowel(sound)
        else
          get_consonant(sound)
        end
      end
      finish
      syllables
    end
  end

  def self.to_syllables(sounds)
    parser = Parser.new sounds
    parser.parse
  end

  def self.split_cluster(cluster)
    coda = cluster
    onset = []
    while POSSIBLE_ONSETS.include?([coda.last] + onset) do
      onset.unshift coda.pop
    end
    [coda, onset]
  end

  def self.to_ipa(sound, unstressed = nil)
    if unstressed && SOUNDS[sound][:ipa_unstressed]
      SOUNDS[sound][:ipa_unstressed]
    else
      SOUNDS[sound][:ipa]
    end
  end

  def self.type(sound)
    SOUNDS[sound.sub /\d/, ''][:type]
  end

  def self.ipa_stress_symbol(stress_level)
    IPA_STRESS_SYMBOLS[stress_level]
  end

  IPA_STRESS_SYMBOLS = { '0' => '.', '1' => "\u02C8", '2' => "\u02CC"}
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

  SOUNDS = {
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