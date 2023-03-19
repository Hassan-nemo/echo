module V1
  module Endpoints
    class Endpoint < Grape::API
      resources :endpoints do # rubocop:disable Metrics/BlockLength
        desc 'Create A new endpoint' do
          success Entities::Endpoint
          failure(
            [
              [422, 'Unprocessable Entity'],
              [400, 'Bad Request']
            ]
          )
        end
        params do
          requires :data, type: Hash do
            requires :type, type: String, values: %w[endpoints]
            requires :attributes, type: Hash do
              requires :verb, type: String, values: Constants::ALLOWED_VERBS
              requires :path, type: String, regexp: Constants::PATH_REGEX
              requires :response, type: Hash do
                requires :code, type: Integer, values: Rack::Utils::HTTP_STATUS_CODES.keys
                optional :headers, type: Hash, default: {}
                optional :body, type: String
              end
            end
          end
        end
        post do
          endpoint = ::Endpoints::Create.execute(params)

          render V1::Entities::Endpoint.new(endpoint).serializable_hash
        end
        desc 'List All existing endpoints' do
          success Entities::Endpoint
          is_array true
        end
        params do
          optional :page, type: Integer, default: 0
          optional :per_page, type: Integer, default: 20
        end
        get do
          endpoint = ::Endpoints::Index.execute(params)

          render V1::Entities::Endpoint.new(endpoint, is_collection: true).serializable_hash
        end

        route_param :id do # rubocop:disable Metrics/BlockLength
          desc 'Update an endpoint' do
            success Entities::Endpoint
            failure(
              [
                [400, 'Bad Request'],
                [404, 'Endpoint Not Found'],
                [422, 'Unprocessable Entity']
              ]
            )
          end
          params do
            requires :data, type: Hash do
              requires :type, type: String, values: %w[endpoints]
              requires :attributes, type: Hash do
                optional :verb, type: String, values: Constants::ALLOWED_VERBS
                optional :path, type: String, regexp: Constants::PATH_REGEX
                optional :response, type: Hash do
                  optional :code, type: Integer, values: Rack::Utils::HTTP_STATUS_CODES.keys
                  optional :headers, type: Hash
                  optional :body, type: String
                end
                at_least_one_of :verb, :path, :response
              end
            end
          end
          patch do
            endpoint = ::Endpoints::Update.execute(params)

            render V1::Entities::Endpoint.new(endpoint).serializable_hash
          end
          desc 'DELETE an endpoint' do
            success Entities::Endpoint
            failure(
              [
                [404, 'Endpoint Not Found'],
                [422, 'Unprocessable Entity']
              ]
            )
          end
          delete do
            ::Endpoints::Destroy.execute(params)

            status :no_content
            body false
          end
        end
      end
    end
  end
end
