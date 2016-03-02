if ENV['run_que']
  Que.clear! if Rails.env.development?
  Que.mode = :async
end
