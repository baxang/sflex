class CreateMedia < ActiveRecord::Migration[5.0]
  def change
    create_table :media do |t|
      t.references :episode, foreign_key: true
      t.string :title
      t.string :uri
      t.text :tag

      t.timestamps
    end
  end
end
