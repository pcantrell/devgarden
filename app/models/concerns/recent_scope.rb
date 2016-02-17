module RecentScope
  extend ActiveSupport::Concern

  def scroll_continuation
    { id: id, t: updated_at.to_f }
  end

  included do
    scope :recent, -> (limit = 20, scroll_continuation: nil) do
      query = order('updated_at desc, id desc').limit(limit)
      if scroll_continuation
        before_id = scroll_continuation[:id]
        before_time = Time.at(scroll_continuation[:t].to_f)
        query = query.where(
          'updated_at <= ? or (updated_at = ? and id < ?)',
          before_time,
          before_time,
          before_id)
      end
      query
    end
  end
end
