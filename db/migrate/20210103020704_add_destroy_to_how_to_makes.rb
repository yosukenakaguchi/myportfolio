class AddDestroyToHowToMakes < ActiveRecord::Migration[6.0]
  def change
    add_column :how_to_makes, :_destroy_line, :boolean, default: false, null: false
  end
end
