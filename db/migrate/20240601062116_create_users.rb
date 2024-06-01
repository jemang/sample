class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :uuid, null: false
      t.string :gender
      t.integer :age
      t.jsonb :name
      t.jsonb :location
      t.jsonb :extras

      t.timestamps
    end
    add_index :users, [:uuid], unique: true
  end
end
