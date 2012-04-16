class RemoveIndexWordsOnCachedSlug < ActiveRecord::Migration
  def up
  	remove_index :words, :cached_slug
  end
end
