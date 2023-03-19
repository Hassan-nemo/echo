module Endpoints
  class Destroy < ::ServicesBase
    def execute
      endpoint.destroy!
    rescue ActiveRecord::ActiveRecordError => _e
      raise ::UnprocessableRecord, "Unable to Delete an endpoint with id #{params[:id]}"
    end

    private

    def endpoint
      @endpoint ||= begin
        Endpoint.find_by!(uuid: params[:id])
      rescue ActiveRecord::RecordNotFound => _e
        raise RecordNotFound, "Endpoint with id #{params[:id]} does not exist"
      end
    end
  end
end
