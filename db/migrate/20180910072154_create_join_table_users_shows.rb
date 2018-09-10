class CreateJoinTableUsersShows < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :shows do |t|
      t.index [:user_id, :show_id]
    end
  end
end
