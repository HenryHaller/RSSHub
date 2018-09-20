class DeleteRequest
  include Interactor

  def call
    user = User.find(context.user_id)
    show = context.show
    show.users.delete(user)
    show.destroy if show.users.count == 0
    # TODO
  end
end
