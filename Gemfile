# frozen_string_literal: true

source "https://rubygems.org"

gem "dotenv"
gem "rubocop-rails-omakase", require: false

gem "graphql"
gem "rack"
gem "serverless-rack"
gem "aws-sdk-dynamodb"

group :development do
  gem "rubocop-rspec"
end

group :test do
  gem "webmock"
end

group :development, :test do
  gem "byebug"
  gem "rspec"
end
