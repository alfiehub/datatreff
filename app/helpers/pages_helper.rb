module PagesHelper
  def front_page_cache_key
    Page.front_page.pluck(:updated_at).reduce{|p, l| p.to_i + l.to_i}
  end
end
