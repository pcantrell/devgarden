module ApplicationHelper
  def recent_projects(updated_before: 100.years.from_now, limit:)
    Project
      .order('updated_at desc')
      .where('updated_at < ?', updated_before)
      .limit(20)
      .includes(:participants, :role_requests)
  end
end
