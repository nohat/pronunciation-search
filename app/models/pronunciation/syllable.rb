class Pronunciation::Syllable
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
      IPA_STRESS_SYMBOLS[peak.stress] or raise "Invalid stress level: #{peak.stress}"
    end
  end
end
