class Page < ActiveRecord::Base
  #  create_table "pages", force: :cascade do |t|
  #    t.string   "title"
  #    t.text     "content"
  #    t.integer  "user_id"
  #    t.boolean  "main_menu",  default: false
  #    t.boolean  "front_page", default: false
  #    t.datetime "created_at",                 null: false
  #    t.datetime "updated_at",                 null: false
  #  end

  NAME_FORMAT = /_?[0-9]*-?[a-zA-Z][a-zA-Z0-9\-]*/

  belongs_to :user

  validates :title, presence: true

  scope :front_page, -> { where(front_page: true) }

  def self.find_by_param(id)
    if id =~ NAME_FORMAT
      find_by_title(id)
    else
      find(id)
    end
  end
end
