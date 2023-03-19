require Rails.root.join('app', 'api', 'v1', 'entities', 'base')

GrapeSwagger.model_parsers.register(GrapeSwagger::Jsonapi::Parser, V1::Entities::Base)
