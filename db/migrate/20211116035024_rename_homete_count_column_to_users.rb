class RenameHometeCountColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :homete_count, :homeru_count
  end
end
