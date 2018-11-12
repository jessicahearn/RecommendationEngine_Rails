class ChangeLikedDefault < ActiveRecord::Migration
  def change
    change_column_default(:user_products, :liked, false)
  end
end
