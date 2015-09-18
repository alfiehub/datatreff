module ResultsHelper
  def not_accepted_cache_key
    Result.not_accepted.pluck(:created_at).reduce{|p, l| p.to_i + l.to_i}
  end
end
