class AdminController < ApplicationController
	authorize_resource :class => :AdminSection

  def index
  	@q = Ad.without_status(:draft, :published).search(params[:q])
    @ads = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 10)
  end

  def ad_types
    @types = AdType.paginate(:page => params[:page], :per_page => 10)
  end

  def users
    @users = User.paginate(:page => params[:page], :per_page => 10)
  end

  def approve_ad
  	@ad = Ad.find(params[:id])
      if current_user.admin? && @ad.new?
        @ad.approve_ad
        redirect_to admin_path, notice: 'ad was successfully approved.'
      else
        redirect_to admin_path, :flash => {:error => 'ad can not approved.'}
      end
  end

  def ban_ad
    @ad = Ad.find(params[:id])
      if current_user.admin? && @ad.new?
        @ad.reject_ad
        redirect_to admin_path, notice: 'ad was successfully baned.'
      else
        redirect_to admin_path, :flash => {:error => 'ad can not baned.'}
      end
  end
end
