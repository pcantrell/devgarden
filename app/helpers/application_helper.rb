module ApplicationHelper
  def recent_projects(**opts)
    recent_models(Project, **opts).includes(:participants, :role_requests)
  end

  def recent_people(**opts)
    recent_models(Person, **opts).includes(:projects, :role_offers)
  end

private

  def recent_models(model, before: nil, limit:)
    query = model
      .order('updated_at desc, id desc')
      .limit(limit)

    if before
      query = query.where(
        'updated_at <= ? and id < ?', before.updated_at, before.id)
    end

    query
  end

end
