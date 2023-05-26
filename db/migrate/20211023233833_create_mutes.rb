class CreateMutes < ActiveRecord::Migration[6.1]
  def change
    create_table :mutes do |t|
      t.integer    :to
      t.integer    :from
      
      t.timestamps
    end
  end
end
