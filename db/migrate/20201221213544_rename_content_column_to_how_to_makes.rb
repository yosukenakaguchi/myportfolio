class RenameContentColumnToHowToMakes < ActiveRecord::Migration[6.0]
  def change
    rename_column :how_to_makes, :content, :make_way
  end
end
