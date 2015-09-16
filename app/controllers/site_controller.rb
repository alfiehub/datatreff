class SiteController < ApplicationController
  def index
    @pages = Page.front_page.order(:position)
    @instagram = Instagram.tag_recent_media("galaxelan", {:count => 5})
  end

  def chat
  end
end
