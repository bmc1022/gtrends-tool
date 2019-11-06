class CreateGtrends < ActiveRecord::Migration[5.2]
  def change
    create_table :gtrends do |t|
      t.timestamps null: false
      
      t.string :name,     default: ""
      t.text   :keywords, default: ""
      t.text   :results,  default: ""
    end
  end
end
