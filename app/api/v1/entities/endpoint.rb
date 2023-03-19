# frozen_string_literal: true

module V1
  module Entities
    class Endpoint < Base
      set_id(&:uuid)
      set_type 'endpoints'

      attributes :verb, :path, :response
    end
  end
end
