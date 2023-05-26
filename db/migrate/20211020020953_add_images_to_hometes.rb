class AddImagesToHometes < ActiveRecord::Migration[6.1]
  def change
    add_column :hometes, :images, :json
  end
end
