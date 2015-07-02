ENV['APP_ROOT'] ||= Dir::pwd

# ワーカープロセス数
worker_processes 5
# worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

# リクエスト処理開始から指定秒数経過しても反応しなければワーカーにSIGKILL
timeout 60 #default 60

# UNIXドメインソケット通信する場合(同一マシン上でnginxを前に置くならこっちのほうが高速）
# Nginxのserver unix:/path/to/unicorn.sock; と合わせておくのを忘れない
# :backlog キューが保持できるリクエストの最大数
# listen "#{app_path}/tmp/sockets/unicorn.sock", backlog: 8192

# :tcp_nopush
#   TCP_CORKによるデータ書きだしタイミングの変更
#   http://blog.nomadscafe.jp/2013/09/benchmark-g-wan-and-nginx.html
#
# :tcp_defer_accept
#   コネクションが完了したタイミングではなく、データが到着した段階でプロセスを起こします
#   http://www.slideshare.net/kazeburo/yapc2013psgi-plack
#
# :tcp_no_delay
#   write時にos/kernelレベルでbufferingしてたまってからsendするのをやめて即座にsendします
#   http://www.slideshare.net/kazeburo/yapc2013psgi-plack
#   
listen 3000, :tcp_nopush => true, tcp_defer_accept: 1
# listen 3000, :tcp_nopush => true, tcp_defer_accept: 1, tcp_no_delay: true

working_directory "#{ENV['APP_ROOT']}"
pid "#{ENV['APP_ROOT']}/tmp/pids/unicorn.pid"

# ログの出力先
stdout_path "#{ENV['APP_ROOT']}/log/unicorn.stdout.log"
stderr_path "#{ENV['APP_ROOT']}/log/unicorn.stderr.log"


# アプリケーションを事前に読み込んでUnicornのワーカープロセス起動時間を短くする
preload_app true

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

# Enable this flag to have unicorn test client connections by writing the
# beginning of the HTTP headers before calling the application.  This
# prevents calling the application for connections that have disconnected
# while queued.  This is only guaranteed to detect clients on the same
# host unicorn runs on, and unlikely to detect disconnects even on a
# fast LAN.
check_client_connection false

run_once = true

# それぞれのワーカープロセスで外部接続を管理できるようにする
before_fork do |server, _worker|
  # Unicornはgraceful shutdownにSIGQUITを使う。
  # Herokuのおすすめと同じようにSIGTERMをマスタープロセスで受信したら、
  # リクエストを完了してからワーカープロセスを終了後にマスタープロセスを終了させる。
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # ActiveRecordとのコネクションを破棄してafter_forkのワーカープロセス内で接続する
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  if run_once
    # do_something_once_here ...
    run_once = false # prevent from firing again
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (_worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  sleep 1

end

after_fork do |server, _worker|
  # 上のbefore_forkを参照
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end


  # 上のbefore_forkを参照
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
