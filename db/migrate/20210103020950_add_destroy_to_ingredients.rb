class AddDestroyToIngredients < ActiveRecord::Migration[6.0]
  def change
    add_column :ingredients, :_destroy_line, :boolean, default: false, null: false
  end
end
