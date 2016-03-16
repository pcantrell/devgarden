if ENV['DEV_GARDEN_RUN_QUE']
  Que.clear! if Rails.env.development?
  Que.mode = :async
end
