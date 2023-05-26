class CreateHometes < ActiveRecord::Migration[6.1]
  def change
    create_table :hometes do |t|
      t.integer :author,            null: false, default: 0
      t.text    :content
      t.integer :image,             default: 0

      t.timestamps
    end
  end
end
