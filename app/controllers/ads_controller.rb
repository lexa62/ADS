class AdsController < ApplicationController
  load_and_authorize_resource

  def index
    if params[:type_id].blank?
      @q = @ads.includes(:ad_type).published.search(params[:q])
    else
      @q = @ads.includes(:ad_type).type(params[:type_id]).search(params[:q])
    end
    @ads = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @ad.images.build
  end

  def edit
  end

  def show
  end

  def create
    @ad.user_id = current_user.id
    respond_to do |format|
      if @ad.save
        format.html { redirect_to @ad, notice: t('controllers.flash.ads.success_create') }
        format.json { render :show, status: :created, location: @ad }
      else
        format.html { render :new }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @ad.update(ad_params)
        format.html { redirect_to @ad, notice: t('controllers.flash.ads.success_update') }
        format.json { render :show, status: :ok, location: @ad }
      else
        format.html { render :edit }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to ads_url, notice: t('controllers.flash.ads.success_destroy') }
      format.json { head :no_content }
    end
  end

  %w(moderating make_draft edit_rejected_ad).each do |meth|
    define_method(meth) do
      if @ad.send('can_' + meth + '?')
        @ad.send(meth)
        redirect_to :my_ads, notice: t('controllers.flash.ads.success_status_update')
      else
        redirect_to :my_ads, :flash => { :error => t('controllers.flash.ads.failure_status_update') }
      end
    end
  end

  %w(approve_ad reject_ad).each do |meth|
    define_method(meth) do
      if @ad.send('can_' + meth + '?')
        session[:return_to] ||= request.referer
        @ad.send(meth)
        redirect_to session.delete(:return_to), notice: t('controllers.flash.ads.success_status_update')
      else
        redirect_to admin_ads_path, :flash => { :error => t('controllers.flash.ads.failure_status_update') }
      end
    end
  end

  def approve_ads
    @ads = Ad.find(params[:ad_ids])
    session[:return_to] ||= request.referer
    @ads.each do |ad|
      if ad.can_approve_ad?
        ad.approve_ad
      else
        redirect_to admin_ads_path, :flash => { :error => t('controllers.flash.ads.failure_approving') } and return
      end
    end
    redirect_to session.delete(:return_to), notice: t('controllers.flash.ads.success_approving')
  end

  private

  def ad_params
    params.require(:ad).permit(:title, :text, :price, :user_id, :ad_type_id, images_attributes: [:id, :file, :_destroy])
  end
end
