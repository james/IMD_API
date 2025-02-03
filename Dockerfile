FROM ruby:3.3

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  sqlite3 \
  spatialite-bin \
  libsqlite3-mod-spatialite

# Set up the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

# Copy the application code
COPY . .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "8080"]