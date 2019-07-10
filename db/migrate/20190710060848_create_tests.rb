class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.text :url
      t.integer :max_ttfb
      t.integer :max_tti
      t.integer :max_speed_index
      t.integer :max_ttfp

      t.timestamps
    end
  end
end
