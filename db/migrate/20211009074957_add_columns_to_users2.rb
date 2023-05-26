class AddColumnsToUsers2 < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :twitter_screen_name, :string
  end
end
