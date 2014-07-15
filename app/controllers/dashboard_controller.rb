class DashboardController < ApplicationController
  load_and_authorize_resource :class => "Ad"

  def ads
    @q = current_user.ads.search(params[:q])
    @ads = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 10)
  end
end
