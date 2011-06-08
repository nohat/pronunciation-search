class CreatePronunciations < ActiveRecord::Migration
  def self.up
    create_table :pronunciations do |t|
      t.string :arpabet
      t.references :word

      t.timestamps
    end
  end

  def self.down
    drop_table :pronunciations
  end
end
