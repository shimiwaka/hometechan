class CreateHomerus < ActiveRecord::Migration[6.1]
  def change
    create_table :homerus do |t|
      t.integer :type,              null: false, default: 0
      t.integer :to,                null: false, default: 0
      t.integer :author,            null: false, default: 0
      t.string :ip_address,         default: ""
      t.timestamps
    end
  end
end
