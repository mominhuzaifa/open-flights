FROM ruby:2.7

# Install Node.js for React.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

WORKDIR /app
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN bundle install

# Copy the package.json from app root into the Docker image
COPY package.json ./

# Install Node.js dependencies
RUN npm install

# Copy the rest of the app code into the Docker image
COPY . .
# Adding a script to be executed every time container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Compile assets and perform database migrations
#RUN bundle exec rake assets:precompile
#RUN bundle exec rake db:migrate

# Expose the port the app runs on
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
