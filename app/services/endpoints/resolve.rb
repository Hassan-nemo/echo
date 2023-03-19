module Endpoints
  class Resolve < ::ServicesBase
    def execute
      Endpoint.where(path: params[:path], verb: params[:verb]).first!
    rescue ActiveRecord::RecordNotFound => _e
      raise RecordNotFound, "Requested page `#{params[:path]}` does not exist"
    end
  end
end
