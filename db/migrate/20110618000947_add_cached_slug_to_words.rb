class AddCachedSlugToWords < ActiveRecord::Migration
  def change
    add_column :words, :cached_slug, :string
    add_index  :words, :cached_slug, :unique => true
  end
end
