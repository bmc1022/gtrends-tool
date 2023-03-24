class AddUniqueIndexesToGtrendAndKeyword < ActiveRecord::Migration[7.0]
  def change
    add_index :gtrends, :name, unique: true
    add_index :keywords, [:kw, :gtrend_id], unique: true
  end
end
