# Rails アプリケーションの始め方の例

## MacにRubyをインストール

```
brew update
brew install rbenv ruby-build

echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
exec $SHELL -l

rbenv --version

# インストール可能なRubyの一覧
rbenv install --list

rbenv install -v 2.2.0
rbenv rehash

rbenv versions

# 全体で使うRubyのバージョンを固定
rbenv global 2.2.0
rbenv rehash

ruby -v
```

## bundlerをインストール
```
gem install bundler
rbenv rehash
```

## MacにMySQLをインストール
```
brew install mysql

# 最初の情報を見落としてもinfoコマンドで何回も閲覧できる
brew info mysql

mysql_install_db --verbose --user=`whoami` --basedir="$(brew --prefix mysql)" --datadir=/usr/local/var/mysql --tmpdir=/tmp
mysql.server start

/usr/local/opt/mysql/bin/mysqladmin -u root password 'root'
/usr/local/opt/mysql/bin/mysql_secure_installation
```

## my.cnfの場所
- グローバル設定     /etc/my.cnf
- サーバ固有の設定   /usr/local/var/mysql/my.cnf
- ユーザー固有の設定 ~/.my.cnf


## アプリケーション開発事始め

```
gem 'rails'
```

```
bundle install --path=vendor/bundle
bundle exec rails new . -d mysql
```


## 毎回のbundle execが面倒な場合はdirenvが便利

```
go get github.com/zimbatm/direnv
echo 'eval "$(direnv hook zsh)"' >> ~/dotfiles/.zshrc
echo 'export PATH=$PWD/.bin:$PATH' > .envrc
exec $SHELL -l
direnv allow
```

## データベースのセットアップ
- database.yml

```
rake db:create
rake db:migrate
```

- db/schema.rb に最初のスキーマを書く

```
rake db:setup
```


# vimでRails開発に便利なgem

```
# termial
gem "tmuxinator"

# vim
gem "gem-ctags"
gem "gem-browse"

# reference
gem "refe2"
gem "bitclust-dev"
gem "bitclust-core"

# guard
gem 'guard'
gem 'guard-rspec'
gem 'guard-bundler'
gem 'terminal-notifier-guard'
gem 'spring'
gem 'spring-commands-rspec'
gem 'rb-fsevent'

# slim
gem 'html2slim'
```


# rails g いろいろ

```
rails g -h
rails g model -h
```

```
rails g model post --skip-migration --skip-fixture --no-test-framework
rails g controller posts index show post --no-test-framework
```


# twitter bootstrapを使う

ダウンロードしてvendorに配置

|ダウンロードファイル|配置先|
|:--|:--|
|dist/css/bootstrap.min.css|vendor/assets/stylesheets/.|
|dist/js/bootstrap.min.js|vendor/assets/javascripts/.|
|dist/fonts|vendor/assets/.|


app/assets/javascripts/application.js

```
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require_tree .
```

app/assets/stylesheets/application.css

```
*= require bootstrap.min
*= require_tree .
*= require_self
*/
```


# rspec ことはじめ

```
group :development, :test do
  gem 'rspec-rails', '~> 3.0'
end
```

```
rails g rspec:install
```
