class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :item_name
      t.string :item_image
      t.jsonb :custom_fields
      t.references :user, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
