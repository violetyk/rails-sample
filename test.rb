require 'webrick'

# Dockerコンテナ内ではフォアに持ってこないとダメ
# Process.daemon
WEBrick::HTTPServer.new(DocumentRoot: './', Port: 3000).start
