class IndexWordSlug < ActiveRecord::Migration
  def up
    add_index :words, :slug, unique: true
  end
end
