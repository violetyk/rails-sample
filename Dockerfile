FROM ruby:2.2.0
MAINTAINER violetyk <yuhei.kagaya@gmail.com>

ENV APP_HOME /app

# RUN mkdir $APP_HOME
# COPY ./test.rb ${APP_HOME}/
# WORKDIR $APP_HOME
# EXPOSE 3000
# CMD ["ruby", "test.rb"]

RUN \
  echo "Asia/Tokyo" > /etc/timezone && \
  cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  apt-get update && \
  apt-get install -qq -y nodejs npm logrotate --no-install-recommends && \
  npm install -g typescript && \
  update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10 && \
  rm -rf /var/lib/apt/lists/* \
  mkdir ${APP_HOME}/ \
  mkdir ${APP_HOME}/tmp \
  mkdir ${APP_HOME}/log


WORKDIR $APP_HOME
COPY [ \
  "./Gemfile", "./Gemfile.lock", "$APP_HOME/" \
]
# RUN bundle install -j`nproc` --path vendor/bundle --without development test staging
RUN bundle install -j`nproc` --path vendor/bundle


COPY . $APP_HOME
EXPOSE 3000
# CMD ["bundle", "exec", "unicorn", "-c", "config/unicorn.rb"]
