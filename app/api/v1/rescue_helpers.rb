# frozen_string_literal: true

module V1
  module RescueHelpers
    extend ActiveSupport::Concern

    included do
      rescue_from Grape::Exceptions::ValidationErrors do |exception|
        error!({ errors: [{ detail: exception.message, code: 'invalid_request' }] }, 400)
      end

      rescue_from ::RecordNotFound do |exception|
        error!({ errors: [{ detail: exception.message, code: exception.code }] }, 404)
      end

      rescue_from ::UnprocessableRecord do |exception|
        error!({ errors: [{ detail: exception.message, code: exception.code }] }, 422)
      end

      rescue_from :all do |_exception|
        error!({ errors: [{ detail: 'Something went wrong!', code: 'internal_server_error' }] }, 500)
      end
    end
  end
end
