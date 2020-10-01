class AddDetailsToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_column :recipes, :title, :string
    add_column :recipes, :work, :string
    add_column :recipes, :author, :string
  end
end
