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

- db/schema.rbに最初のスキーマを書く

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
```
