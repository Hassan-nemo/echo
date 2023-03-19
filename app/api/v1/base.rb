# frozen_string_literal: true

require_relative 'rescue_helpers'

module V1
  class Base < Grape::API
    content_type :json, 'application/vnd.api+json'
    default_format :json

    include V1::RescueHelpers

    # Authentication layer here not added as it's not required
    # was thinking to keep it simple with API_KEY and set the user here.
    # before do
    # end

    mount V1::Endpoints::Endpoint
    mount V1::Endpoints::Mock # keep it last line as a fallback

    before do
    end

    add_swagger_documentation format: :json,
                              info: {
                                title: 'Echo API'
                              },
                              models: [
                                V1::Entities::Endpoint
                              ]
  end
end
