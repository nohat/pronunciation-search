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

  def self.to_syllable_data(sounds)
    in_starting_onset = true
    consonant_queue = []
    syllables = []
    current_syllable = {}
    sounds.each do |sound|
      if (type(sound) == :vowel)
        if in_starting_onset
          current_syllable[:onset] = consonant_queue
          current_syllable[:peak] = sound
          consonant_queue = []
          in_starting_onset = false
        else
          coda, onset = cluster_split(consonant_queue)
          current_syllable[:coda] = coda
          syllables.push current_syllable
          current_syllable = {}
          current_syllable[:onset] = onset
          current_syllable[:peak] = sound
          consonant_queue = []
        end
      else
        consonant_queue.push sound
      end
    end
    current_syllable[:coda] = consonant_queue
    syllables.push current_syllable
    syllables
  end

  def self.sonority_level(sound)
    SONORITY_HIERARCHY[type(sound)]
  end
  
  def self.type(sound)
    SOUNDS[sound.sub /\d/, ''][:type]
  end
  
  def self.voiced?(sound)
    SOUNDS[sound][:voice]
  end
  
  def self.voiceless?(sound)
    not voiced? sound
  end
  
  def self.s_cluster?(sound)
    return false if sound.nil?
    voiceless?(sound) && type(sound) == :stop
  end
  
  def self.vowel?(sound)
    type(sound) == :vowel
  end

  def self.cluster_split(cluster)
    coda = cluster.clone
    onset = []
    while ! coda.empty? && possible_onset_sequence(coda.last, onset.first) do
      onset.unshift coda.pop
    end
    # SP, ST, SK, SPL, STR, etc.
    if ! coda.empty? && coda.last == 'S' && s_cluster?(onset.first)
      onset.unshift coda.pop
    end
    [coda, onset]
  end
  
  def self.possible_onset_sequence(sound1, sound2)
    return true if sound2.nil?
    # no DL, TL
    return false if sound2 == 'L' && %W[D T].include?(sound1)
    return true if sonority_level(sound1) < sonority_level(sound2)
    false
  end

  SONORITY_HIERARCHY = {
    :vowel => 10,
    :semivowel => 9,
    :liquid => 8,
    :nasal => 7,
    :fricative => 5,
    :aspirate => 5,
    :affricate => 5,
    :stop => 5
  }
  SOUNDS = {
    'P' => { :type => :stop, :voice => false },
    'B' => { :type => :stop, :voice => true },
    'T' => { :type => :stop, :voice => false  },
    'D' => { :type => :stop, :voice => true },
    'K' => { :type => :stop, :voice => false  },
    'G' => { :type => :stop, :voice => true },
    'CH' => { :type => :affricate, :voice => false  },
    'JH' => { :type => :affricate, :voice => true },
    'TH' => { :type => :fricative, :voice => false  },
    'DH' => { :type => :fricative, :voice => true },
    'F' => { :type => :fricative, :voice => false  },
    'V' => { :type => :fricative, :voice => true },
    'S' => { :type => :fricative, :voice => false  },
    'Z' => { :type => :fricative, :voice => true },
    'SH' => { :type => :fricative, :voice => false  },
    'ZH' => { :type => :fricative, :voice => true },
    'HH' => { :type => :aspirate, :voice => false  },
    'M' => { :type => :nasal, :voice => true },
    'N' => { :type => :nasal, :voice => true },
    'NG' => { :type => :nasal, :voice => true },
    'R' => { :type => :liquid, :voice => true },
    'L' => { :type => :liquid, :voice => true },
    'W' => { :type => :semivowel, :voice => true },
    'Y' => { :type => :semivowel, :voice => true },
    'AA' => { :type => :vowel, :voice => true },
    'AE' => { :type => :vowel, :voice => true },
    'AH' => { :type => :vowel, :voice => true },
    'AO' => { :type => :vowel, :voice => true },
    'AW' => { :type => :vowel, :voice => true },
    'AY' => { :type => :vowel, :voice => true },
    'EH' => { :type => :vowel, :voice => true },
    'ER' => { :type => :vowel, :voice => true },
    'EY' => { :type => :vowel, :voice => true },
    'IH' => { :type => :vowel, :voice => true },
    'IY' => { :type => :vowel, :voice => true },
    'OW' => { :type => :vowel, :voice => true },
    'OY' => { :type => :vowel, :voice => true },
    'UH' => { :type => :vowel, :voice => true },
    'UW' => { :type => :vowel, :voice => true },
  }

end
