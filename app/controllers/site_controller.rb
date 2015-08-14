class SiteController < ApplicationController
  def index
    @pages = Page.front_page.order(:position)
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
  end

  def chat
  end
end
