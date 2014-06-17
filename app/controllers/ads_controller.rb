class AdsController < ApplicationController
	load_and_authorize_resource :except => :index
	def index
		@ads = Ad.paginate(:page => params[:page], :per_page => 5)
	end

	def new
		
	end
end
