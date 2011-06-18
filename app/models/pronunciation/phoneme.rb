class Pronunciation::Phoneme
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
    'DH' => { :type => :consonant, :ipa => "\u00F0" },
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
