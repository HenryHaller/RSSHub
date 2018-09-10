class CreateEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :episodes do |t|
      t.references :show, foreign_key: true
      t.string :url
      t.string :title
      t.string :duration, default: '00:00:00'
      t.string :episode_img

      t.timestamps
    end
  end
end
