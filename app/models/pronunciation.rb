class Pronunciation < ActiveRecord::Base
  belongs_to :word
  
  def as_json(options)
    arpabet
  end
  
end
