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
    return @syllables if @syllables
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
end