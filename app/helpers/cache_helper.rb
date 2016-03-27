module CacheHelper
  def project_cache_key(project)
    [
      project,
      project.participants.maximum(:updated_at),
      Tag.maximum(:updated_at)
    ]
  end
end
