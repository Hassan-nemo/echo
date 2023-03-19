module Endpoints
  class Index < ::ServicesBase
    DEFAULT_PAGE = 0
    DEFAULT_PER_PAGE = 20

    def execute
      Endpoint.all.page(page).per(per_page)
    end

    private

    def page
      params[:page] || DEFAULT_PAGE
    end

    def per_page
      params[:per_page] || DEFAULT_PER_PAGE
    end
  end
end
