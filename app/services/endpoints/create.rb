module Endpoints
  class Create < ::ServicesBase
    def execute
      ::Endpoint.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      raise ::UnprocessableRecord, e.message
    end
  end
end
