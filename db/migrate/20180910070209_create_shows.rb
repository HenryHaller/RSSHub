class CreateShows < ActiveRecord::Migration[5.2]
  def change
    create_table :shows do |t|
      t.string :title
      t.string :small_title
      t.string :rss_url
      t.string :show_img
      t.text :data

      t.timestamps
    end
  end
end
