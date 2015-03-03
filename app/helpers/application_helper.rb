module ApplicationHelper
  def recent_projects(before: nil, limit:)
    query = Project
      .order('updated_at desc, id desc')
      .limit(limit)
      .includes(:participants, :role_requests)

    if before
      query = query.where(
        'updated_at <= ? and id < ?', before.updated_at, before.id)
    end

    query
  end
end
