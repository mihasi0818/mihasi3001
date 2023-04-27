FROM --platform=linux/x86_64 ruby:3.2.2
ENV RAILS_ENV=production

RUN apt-get update -qq && apt-get install -y postgresql-client

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

COPY start.sh /start.sh
RUN chmod 744 /start.sh
CMD ["sh","/start.sh","bundle", "exec", "puma", "-C", "config/puma.rb"]
