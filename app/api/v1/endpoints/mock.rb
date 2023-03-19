module V1
  module Endpoints
    class Mock < Grape::API
      before do
        @verb = request.env['REQUEST_METHOD']
        @path = request.env['REQUEST_PATH'] || request.env['PATH_INFO']
      end

      route :any, '*path' do
        endpoint_response = ::Endpoints::Resolve
                            .execute({ path: @path, verb: @verb })
                            .response

        status endpoint_response['code']
        endpoint_response['headers'].each { |pair| header pair[0], pair[1] }
        render endpoint_response['body']
      end
    end
  end
end
