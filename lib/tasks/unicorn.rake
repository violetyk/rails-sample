namespace :unicorn do
  desc 'Start Unicorn'
  task :start do
    config = "#{Rails.root}/config/unicorn.rb"
    rails_env = ENV['RAILS_ENV'] || "development"
    sh "bundle exec unicorn -c #{config} -D -E #{rails_env}"
  end

  desc 'Stop Unicorn'
  task :stop do
    unicorn_signal :QUIT
  end

  desc 'Restart Unicorn'
  task :restart do
    unicorn_signal :USR2
  end

  desc "Increment number of worker processes"
  task :increment do
    unicorn_signal :TTIN
  end

  desc "Decrement number of worker processes"
  task :decrement do
    unicorn_signal :TTOU
  end

  desc "Unicorn pstree (depends on pstree command)"
  task :pstree do
    sh "pstree '#{unicorn_pid}'"
  end
end

def unicorn_signal signal
  pid = unicorn_pid
  Process.kill signal, pid
rescue Errno::ENOENT
  puts "Unicorn doesn't seem to be running"
end

def unicorn_pid
  File.read("#{Rails.root}/tmp/pids/unicorn.pid").to_i
rescue Errno::ENOENT
  puts "Unicorn doesn't seem to be running"
end
