class Pronunciation::Parser
  attr_accessor :syllables, :current_syllable, :vowel, :consonant_queue

  def initialize(input)
    @input = input
    @syllables = []
    @consonant_queue = []
    @current_syllable = Pronunciation::Syllable.new
    super()
  end

  state_machine :state, :initial => :initial_onset do
    event :get_consonant do
      transition :initial_onset => :initial_onset
      transition [:vowel, :consonant] => :consonant
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
      coda, onset = pr.split_consonant_cluster
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

  POSSIBLE_ONSETS = [
    ['P'], ['B'], ['T'], ['D'], ['K'], ['G'],
    ['CH'], ['JH'],
    ['TH'], ['DH'], ['F'], ['V'], ['S'], ['Z'], ['SH'], ['ZH'], ['HH'],
    ['M'], ['N'], ['R'], ['L'], ['W'], ['Y'],
    %W[P L], %W[B L], %W[K L], %W[G L], %W[F L], %W[S L],
    %W[P R], %W[B R], %W[T R], %W[D R], %W[K R], %W[G R], %W[F R], %W[TH R],
    %W[T W], %W[K W], %W[HH W], %W[S W],
    %W[P Y], %W[B Y], %W[K Y], %W[G Y], %W[M Y], %W[F Y], %W[V Y], %W[TH Y], %W[HH Y],
    %W[S P], %W[S T], %W[S K], %W[S M], %W[S N], %W[S P R], %W[S T R], %W[S K R], %W[S M Y],
  ]
  # TODO: handle SH R mush|room vs.en|shrine
  # TODO: handle D Y good|year vs. en|dure

  def split_consonant_cluster
    coda = consonant_queue.clone
    onset = []
    while POSSIBLE_ONSETS.include?([coda.last.try(:symbol)] + onset.map {|phoneme| phoneme.symbol}) do
      onset.unshift coda.pop
    end
    [coda, onset]
  end
end
