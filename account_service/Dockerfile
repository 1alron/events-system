FROM ruby:3.3

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD sh -c "rm -f /app/tmp/pids/server.pid && rails db:create && rails db:migrate && rails server -b 0.0.0.0"