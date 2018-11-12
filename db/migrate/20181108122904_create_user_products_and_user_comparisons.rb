class CreateUserProductsAndUserComparisons < ActiveRecord::Migration
  def change
    create_join_table :products, :users, table_name: :user_products do |t|
      t.index :user_id
      t.index :product_id
      t.boolean :liked,                 default: true
      t.boolean :disliked,              default: false
      t.decimal :predicted_likability,  default: 0.0
    end

    create_table :user_comparisons do |t|
      t.integer :user_id
      t.integer :compared_user_id
      t.decimal :jaccard_index,         default: 0.0
    end
  end
end
