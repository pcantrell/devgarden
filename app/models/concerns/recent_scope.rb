module RecentScope
  extend ActiveSupport::Concern

  included do
    scope :recent, -> (limit = 20, before: nil) do
      query = order('updated_at desc, id desc').limit(limit)
      if before
        query = query.where(
          'updated_at <= ? and id < ?', before.updated_at, before.id)
      end
      query
    end
  end
end
