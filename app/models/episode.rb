class Episode < ApplicationRecord
  belongs_to :show, touch: true
  validates :title, presence: true
  validates :title, uniqueness: { scope: :show }
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
