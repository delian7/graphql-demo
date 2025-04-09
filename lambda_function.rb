# frozen_string_literal: true

require 'json'
require 'aws-sdk-dynamodb'

def fetch_missions
  dynamodb = Aws::DynamoDB::Client.new(region: 'us-east-1')
  params = {
    table_name: 'missions',
  }

  begin
    result = dynamodb.scan(params)
    return result.items
  rescue Aws::DynamoDB::Errors::ServiceError => e
    puts "Unable to scan table: #{e.message}"
    return []
  end
end

def lambda_handler(event:, context:) # rubocop:disable Lint/UnusedMethodArgument
  http_method = event['httpMethod'] if event
  # GraphQL requests typically come in as POST requests with a JSON payload

  case http_method
  when 'GET'
    # For GET requests, return the missions from DynamoDB.
    send_response(fetch_missions)
  when 'POST'
    # For POST requests, assume a GraphQL query is sent in the body.
    body = JSON.parse(event['body'] || '{}')
    query = body['query']
    variables = body['variables'] || {}
    operation_name = body['operationName']

    result = Schema.execute(query, variables: variables, context: {}, operation_name: operation_name)
    send_response(result)
  else
    method_not_allowed_response
  end
rescue StandardError => e
  error_response(e)
end

def send_response(data)
  {
    'statusCode' => 200,
    'body' => JSON.generate(data)
  }
end

def method_not_allowed_response
  {
    'statusCode' => 405,
    'body' => JSON.generate({ error: 'Method Not Allowed' })
  }
end

def error_response(error)
  {
    'statusCode' => 500,
    'body' => JSON.generate({ error: error.message })
  }
end
