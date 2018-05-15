FROM ruby:2.4.1

# Install essential linux packages
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    nodejs-legacy nodejs-dev npm \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get install npm

RUN npm i -g yarn
 
# Define where the application will live inside the image
ENV RAILS_ROOT /var/www/app
 
# Create application home. App server will need the pids dir
RUN mkdir -p $RAILS_ROOT/tmp/pids
 
# Set our working directory inside the image
WORKDIR $RAILS_ROOT
 
# Install bundler
RUN gem install bundler
 
# Use the Gemfiles as Docker cache markers. Always bundle before copying app src.
 
COPY Gemfile $RAILS_ROOT/Gemfile
 
COPY Gemfile.lock $RAILS_ROOT/Gemfile.lock
 
# Finish establishing our Ruby enviornment
RUN bundle install
 
# Copy the Rails application into place
COPY . .
 
# RUN RAILS_ENV=production bin/rails assets:precompile

EXPOSE 3000

 
CMD bundle exec rails server -b 0.0.0.0 --port 3000