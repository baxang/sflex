class CreateEpisodes < ActiveRecord::Migration[5.0]
  def change
    create_table :episodes do |t|
      t.references :series, foreign_key: true

      t.string :title
      t.string :uri
      t.datetime :visited_at

      t.timestamps
    end

    add_index :episodes, :uri
  end
end
