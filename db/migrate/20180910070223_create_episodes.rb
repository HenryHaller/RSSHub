class CreateEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :episodes do |t|
      t.references :show, foreign_key: true
      t.string :url
      t.string :title
      t.integer :duration
      t.string :episode_img
      t.text :description
      t.datetime :pub_date

      t.timestamps
    end
  end
end
