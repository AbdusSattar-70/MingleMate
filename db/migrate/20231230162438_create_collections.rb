class CreateCollections < ActiveRecord::Migration[7.1]
  def change
    create_table :collections do |t|
      t.string :title
      t.text :description
      t.string :image
      t.jsonb :custom_fields
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
