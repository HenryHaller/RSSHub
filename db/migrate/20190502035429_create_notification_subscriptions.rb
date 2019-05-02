class CreateNotificationSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :notification_subscriptions do |t|
      t.references :user, foreign_key: true
      t.references :show, foreign_key: true
      t.boolean :subscribed, default: true

      t.timestamps
    end
  end
end
