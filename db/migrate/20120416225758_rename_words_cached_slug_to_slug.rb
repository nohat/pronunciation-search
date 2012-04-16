class RenameWordsCachedSlugToSlug < ActiveRecord::Migration
  def up
    rename_column :words, :cached_slug, :slug
  end

  def down
    rename_column :words, :slug, :cached_slug
  end
end
