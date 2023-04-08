class AddUserToGtrends < ActiveRecord::Migration[7.0]
  def change
    add_reference :gtrends, :user, foreign_key: true, null: true
  end
end
