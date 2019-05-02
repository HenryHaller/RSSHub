class AddP256DhAndAuthToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :p256dh, :string
    add_column :subscriptions, :auth, :string
  end
end
