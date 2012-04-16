class DropSlugs < ActiveRecord::Migration
  def up
  	drop_table :slugs
  end
end
