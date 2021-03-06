listen 8080
worker_processes 1
working_directory File.expand_path('../../../../current', __FILE__)
pid File.expand_path('../../../tmp/pids/unicorn.pid', __FILE__)
preload_app true
timeout 30

stderr_path File.expand_path('../../../log/unicorn_stderr.log', __FILE__)
stdout_path File.expand_path('../../../log/unicorn_stdout.log', __FILE__)

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = File.join(File.expand_path('../../../..', __FILE__), 'current', 'Gemfile')
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
