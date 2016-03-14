if ENV['run_que'] || Rails.env.production?
  Que.clear! if Rails.env.development?
  Que.mode = :async
end
