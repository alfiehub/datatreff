class SiteController < ApplicationController
  def index
    @pages = Page.front_page.order(:position)
  end

  def chat
  end
end
