class CreateCategorizables < ActiveRecord::Migration[7.1]
  def change
    create_table :categorizables do |t|
      t.belongs_to :category, null: false, foreign_key: true
      t.belongs_to :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
