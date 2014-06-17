class AdsController < ApplicationController
	def index
		@ads = Ad.paginate(:page => params[:page], :per_page => 5)
	end
end
