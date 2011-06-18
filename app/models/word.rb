class Word < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
  has_many :pronunciations

  module Matches
    def pronunciation_matches(query)
      Pronunciation.where('arpabet like ?', "%#{query}%").includes(:word => :pronunciations).map do |pron|
        {:result => pron.word, :score => Text::Levenshtein.distance(pron.arpabet, query)}
      end
    end

    def spelling_matches(query)
      where('name like ?', "%#{query}%").includes(:pronunciations).map do |word|
        {:result => word, :score => Text::Levenshtein.distance(word.name, query)}
      end
    end

    def matches(query)
      all_matches = spelling_matches(query) + pronunciation_matches(query)
      all_matches.sort_by { |match| match[:score] }.map { |match| match[:result] }
    end
  end
  
  extend Matches

  def normalize_friendly_id(text)
    text = super
    if friendly_id_config.reserved_words.include? text
      'x-' + text
    else
      text
    end
  end
end
