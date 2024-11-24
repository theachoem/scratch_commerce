module QueryCounter
  def self.track
    @query_count = { read: 0, write: 0 }
    ActiveSupport::Notifications.subscribe("sql.active_record") do |_, _, _, _, details|
      sql = details[:sql].to_s.downcase

      if sql.match?(/\b(select)\b/) && !sql.match?(/\b(insert|update|delete)\b/)
        @query_count[:read] += 1
      elsif sql.match?(/\b(insert|update|delete)\b/)
        @query_count[:write] += 1
      end
    end
  end

  def self.reset!
    @query_count = { read: 0, write: 0 }
  end

  def self.counts
    @query_count || { read: 0, write: 0 }
  end
end
