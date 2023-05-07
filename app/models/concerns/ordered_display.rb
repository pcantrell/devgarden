module OrderedDisplay
  extend ActiveSupport::Concern

  def scroll_continuation
    { id: id, o: display_order }
  end

  def bump_display_order!
    self.display_order =
      [
        (created_at || Time.now) + NEWCOMER_BONUS,             # New records get a boost
        Time.now - METADATA_PENALTY * (1 - metadata_quality),  # Reward icons, descriptions, etc. for older records
        Time.at((display_order || 0) / 1000.0),                # Just in case, so display order never regresses
      ].max.to_f * 1000
  end

  NEWCOMER_BONUS = 10.days
  METADATA_PENALTY = 5.days

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
      if changed.any? { |attr| attr !~ /_at$|display_order/ }  # Don't bump to top just for updated_at / logged_in_at
        bump_display_order!
      end
    end
  end
end
