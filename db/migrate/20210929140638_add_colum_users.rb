class AddColumUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :screen_name, :string
  end
end
