FROM ruby:2.2.0
MAINTAINER violetyk <yuhei.kagaya@gmail.com>

ENV APP_HOME /app

RUN echo "Asia/Tokyo" > /etc/timezone
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apt-get update

RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Set up gems
ADD ./Gemfile $APP_HOME/Gemfile
ADD ./Gemfile.lock $APP_HOME/Gemfile.lock
RUN bundle install -j`nproc` --path vendor/bundle --without development test staging

EXPOSE 3000

ADD . $APP_HOME

# CMD ["bundle", "exec", "foreman", "start"]
