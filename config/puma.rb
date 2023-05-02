workers Integer(ENV.fetch("WEB_CONCURRENCY") { 0 })
max_threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS") { 5 })
min_threads_count = Integer(ENV.fetch("RAILS_MIN_THREADS") { max_threads_count })
threads min_threads_count, max_threads_count

preload_app!

rackup      DefaultRackup
port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RACK_ENV") { "development" }

before_fork do
  require 'puma_worker_killer'
  PumaWorkerKiller.enable_rolling_restart
end

on_worker_boot do
  ActiveRecord::Base.establish_connection
end


