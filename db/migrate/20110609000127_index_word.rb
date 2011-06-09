class IndexWord < ActiveRecord::Migration
  def self.up
    add_index(:words, :name)
  end

  def self.down
    remove_index(:words, :name)
  end
end
