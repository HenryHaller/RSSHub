module CustomSerializers

  def basic_serializer(record)
    { updated_at: record.updated_at, created_at: record.created_at, id: record.id }
  end

  def show_serializer(show)
    basic = basic_serializer(show)
    basic["notifications"] = show.notification_subscriptions.find_by(user: current_user).subscribed
    { title: show.title, show_img: show.show_img }.merge(basic)
  end
end