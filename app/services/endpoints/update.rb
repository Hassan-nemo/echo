module Endpoints
  class Update < ::ServicesBase
    def execute
      endpoint.update!(update_params)

      endpoint
    rescue ActiveRecord::RecordInvalid => e
      raise ::UnprocessableRecord, e.message
    rescue ActiveRecord::ActiveRecordError => _e
      raise ::UnprocessableRecord, "Unable to update an endpoint with params #{params}"
    end

    private

    def update_params
      endpoint.attributes.deep_merge(attributes)
    end

    def endpoint
      @endpoint ||= begin
        Endpoint.find_by!(uuid: params[:id])
      rescue ActiveRecord::RecordNotFound => _e
        raise RecordNotFound, "Endpoint with id #{params[:id]} does not exist"
      end
    end
  end
end
