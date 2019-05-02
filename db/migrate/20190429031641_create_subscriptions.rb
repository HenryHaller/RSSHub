class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :endpoint
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
