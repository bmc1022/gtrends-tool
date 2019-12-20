class CreateKeywords < ActiveRecord::Migration[5.2]
  def change
    create_table :keywords do |t|
      t.timestamps null: false
      
      t.belongs_to :gtrend
      t.string :kw
      t.integer :avg_5y, default: 0
    end
  end
end
