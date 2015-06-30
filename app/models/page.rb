class Page < ActiveRecord::Base
  NAME_FORMAT = /_?[0-9]*-?[a-zA-Z][a-zA-Z0-9\-]*/

  belongs_to :user

  def self.find_by_param(id)
    if id =~ NAME_FORMAT
      find_by_title(id)
    else
      find(id)
    end
  end
end
