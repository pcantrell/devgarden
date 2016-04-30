module OrderedDisplay
  extend ActiveSupport::Concern

  def scroll_continuation
    { id: id, o: display_order }
  end

  included do

    scope :recent, -> (limit = 20, scroll_continuation: nil) do
      query = order('display_order desc, id desc').limit(limit)
      if scroll_continuation
        before_id = scroll_continuation[:id]
        before_order = scroll_continuation[:o]
        query = query.where(
          'display_order < ? or (display_order = ? and id < ?)',
          before_order,
          before_order,
          before_id)
      end
      query
    end

    before_save do
      self.display_order =
        [
          created_at || Time.now,
          Time.now - 1.month * (1 - metadata_quality)
        ].max.to_i * 1000
    end
  end
end
