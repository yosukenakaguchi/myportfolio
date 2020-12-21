class CreateRecipeTagRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :recipe_tag_relationships do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
      add_index :recipe_tag_relationships, [:recipe_id,:tag_id],unique: true
  end
end
