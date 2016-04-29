if ENV['DEV_GARDEN_RUN_QUE']
  Que.clear! if Rails.env.development? && ENV['DEV_GARDEN_CLEAR_QUE']
  Que.mode = :async
end
