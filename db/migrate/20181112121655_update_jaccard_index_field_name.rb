class UpdateJaccardIndexFieldName < ActiveRecord::Migration
  def change
    rename_column :user_comparisons, :jaccard_index, :similarity_index
  end
end
