class RenameTypeColumnsToHomerus < ActiveRecord::Migration[6.1]
  def change
    rename_column :homerus, :type, :hometype
  end
end
