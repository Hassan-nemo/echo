Rails.application.routes.draw do
  mount GrapeSwaggerRails::Engine => '/api/echo/docs'
  mount Api => '/'
end
