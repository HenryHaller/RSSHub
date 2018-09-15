class EpisodeSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :pub_date, :description, :show_title, :show_img
  belongs_to :show

  def show_title
    object.show.title
  end

  def show_img
    object.show.show_img
  end
end
