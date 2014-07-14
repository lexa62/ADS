module Admin
  class AdsController < BaseController
    load_and_authorize_resource

    def index
      @q = Ad.without_status(:draft, :published).search(params[:q])
      @ads = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 10)
    end

    def show
    end
  end
end
