class AdminController < ApplicationController
	authorize_resource :class => :AdminSection
  def index
  	@ads = Ad.without_status(:draft).paginate(:page => params[:page], :per_page => 10)
  end
end
