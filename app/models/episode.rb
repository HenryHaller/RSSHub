class Episode < ApplicationRecord
  belongs_to :show, touch: true
  validates :title, presence: true
  validates :title, uniqueness: { scope: :show }

  def as_json(options)
    json = super
    json["show_title"] = show.title
    json["show_img"] = show.show_img
    json
  end

  def safe_title
    t = title
    t.tr!("'", "")
    t.tr!('"', "")
    t.tr!('(', '')
    t.tr!(')', '')
    t.tr!('/', ' ')
    t.tr!(' ', '_')
    t
  end
end
