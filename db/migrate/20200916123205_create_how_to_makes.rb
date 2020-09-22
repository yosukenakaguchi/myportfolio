class CreateHowToMakes < ActiveRecord::Migration[6.0]
  def change
    create_table :how_to_makes do |t|
      t.text :content
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
