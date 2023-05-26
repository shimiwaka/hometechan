class RemoveImagesFromHometes < ActiveRecord::Migration[6.1]
  def change
    remove_column :hometes, :images, :string
  end
end
