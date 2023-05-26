class RenameImageColumnToHometes < ActiveRecord::Migration[6.1]
  def change
    rename_column :hometes, :image, :images
  end
end
