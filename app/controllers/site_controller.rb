class SiteController < ApplicationController
  def index
    @pages = Page.front_page
    @markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, tables: true)
  end
end
