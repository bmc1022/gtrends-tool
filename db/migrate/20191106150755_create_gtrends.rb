class CreateGtrends < ActiveRecord::Migration[5.2]
  def change
    create_table :gtrends do |t|
      t.timestamps null: false
      
      t.string :name
    end
  end
end
