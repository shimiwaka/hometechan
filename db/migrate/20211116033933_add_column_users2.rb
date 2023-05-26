class AddColumnUsers2 < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :homete_count, :integer, default: 0
    add_column :users, :homerare_count, :integer, default: 0
  end
end
