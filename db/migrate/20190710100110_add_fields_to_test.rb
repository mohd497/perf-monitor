class AddFieldsToTest < ActiveRecord::Migration[5.2]
  def change
  	add_column :tests, :ttfb, :integer
  	add_column :tests, :tti, :integer
  	add_column :tests, :speed_index, :integer
  	add_column :tests, :ttfp, :integer
  	add_column :tests, :is_passed, :boolean
  end
end
