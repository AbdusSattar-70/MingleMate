class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :email
      t.string :password
      t.string :avatar
      t.integer :role
      t.boolean :blocked

      t.timestamps
    end
  end
end
