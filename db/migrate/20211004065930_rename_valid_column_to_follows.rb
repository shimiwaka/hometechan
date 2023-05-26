class RenameValidColumnToFollows < ActiveRecord::Migration[6.1]
  def change
    rename_column :follows, :valid, :enable
  end
end
