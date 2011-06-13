class Pronunciation < ActiveRecord::Base
  belongs_to :word
  
  def as_json(options)
    arpabet
  end
  
  def to_s
    "/#{arpabet}/"
  end
  
end
