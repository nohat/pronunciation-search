class Word < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
  has_many :pronunciations
  cattr_reader :per_page
  @@per_page = 500
#  @@per_page = 10

#  def as_json(options)
#    super(options.merge :except => [:updated_at, :created_at], :include => :pronunciations)
#  end
end
