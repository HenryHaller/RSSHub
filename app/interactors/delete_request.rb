class DeleteRequest
  include Interactor

  def call
    user = context.current_user
    show = context.show
    show.users.delete(user)
    show.destroy if show.users.count.zero?
  end
end
