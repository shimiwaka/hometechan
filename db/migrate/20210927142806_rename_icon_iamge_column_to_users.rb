class RenameIconIamgeColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :icon_iamge, :icon_image
  end
end
