FactoryBot.define do
  factory :endpoint do
    verb { 'GET' }
    path { "/greeting" }
    response { { 'code': 200 } }

    trait :with_invalid_code do
    end

    trait :with_full_headers_and_body do
      response do
        {
          "code": 200,
          "headers": {
            "Content-Type": "application/json"
          },
          "body": "\"{ \"message\": \"Hello, world\" }\""
        }
      end
    end

    trait :with_invalid_response do
      response do
        {
          "headers": {
            "Content-Type": 1
          },
          "body": 7
        }
      end
    end
  end
end
