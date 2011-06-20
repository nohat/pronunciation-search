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

  module Search
    def search(query)
      like = query.length > 2 ? ".*#{query}.*" : "^#{query}$"
      clause, params = parse_query(query)
      raise 'No query found' if clause.blank?
      matches = Pronunciation.includes(:word).where(clause, *params).map do |pron|
        {:result => pron, :score => Text::Levenshtein.distance(pron.arpabet, query)}
      end
      matches.sort_by { |match| match[:score] }.map { |match| match[:result] }
    end
    
    def parse_query(query)
      params = []
      conditions = []
      spellings      = query.scan(/(~)?\|(.*?)\|/)
      pronunciations = query.scan(/(~)?\/(.*?)\//)
      spellings.each do |neg, string|
        params << string
        conditions << "words.name#{neg ? ' NOT ' : ' '}REGEXP ?"
      end
      pronunciations.each do |neg, string|
        string.gsub!(/\b(AA|AE|AH|AO|AW|AY|EH|ER|EY|IH|IY|OW|OY|UH|UW)\b/, '\1.')
        params << string
        conditions << "arpabet#{neg ? ' NOT ' : ' '}REGEXP ?"
      end
      clause = conditions.join ' AND '
      return clause, params
    end
  end

  extend Search
end