module ResultsHelper
  def not_accepted_cache_key
    Result.not_accepted.pluck(:created_at).reduce{|p, l| p.to_i + l.to_i}
  end

  def results_cache_key c_id
    Competition.find_by_id(c_id).results.pluck(:updated_at).reduce{|p, l| p.to_i + l.to_i}
  end
end
