class Word < ActiveRecord::Base
  has_friendly_id :name, :use_slug => true
  has_many :pronunciations
  cattr_reader :per_page
  @@per_page = 500
end
