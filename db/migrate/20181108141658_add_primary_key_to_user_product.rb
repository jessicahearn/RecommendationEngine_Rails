class AddPrimaryKeyToUserProduct < ActiveRecord::Migration
  def change
    add_column :user_products, :id, :primary_key
  end
end
