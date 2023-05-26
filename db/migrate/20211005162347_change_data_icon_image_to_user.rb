class ChangeDataIconImageToUser < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :icon_image, :string
  end
end
