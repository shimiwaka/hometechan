class RenameTypeColumnsToNotifications < ActiveRecord::Migration[6.1]
  def change
    rename_column :notifications, :type, :notitype
  end
end
