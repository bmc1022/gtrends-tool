class AddGuestIdToGtrends < ActiveRecord::Migration[7.0]
  def change
    add_column :gtrends, :guest_id, :string
  end
end
