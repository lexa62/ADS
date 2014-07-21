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
        format.html { redirect_to @ad, notice: 'ad was successfully created.' }
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
        format.html { redirect_to @ad, notice: 'ad was successfully updated.' }
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
      format.html { redirect_to ads_url, notice: 'ad was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def moderating
    if @ad.user_id == current_user.id && @ad.draft?
      @ad.moderating
      redirect_to :my_ads, notice: 'ad was successfully published.'
    else
      redirect_to :my_ads, :flash => {:error => 'ad can not published.'}
    end
  end

  def make_draft
    if @ad.user_id == current_user.id && @ad.archive?
      @ad.make_draft
      redirect_to :my_ads, notice: 'ad was successfully move in drafts.'
    else
      redirect_to :my_ads, :flash => {:error => 'ad can not moved in drafts.'}
    end
  end

  def edit_rejected_ad
    if @ad.user_id == current_user.id && @ad.rejected?
      @ad.edit_rejected_ad
      redirect_to :my_ads, notice: 'ad was successfully moved in drafts.'
    else
      redirect_to :my_ads, :flash => {:error => 'ad can not moved in drafts.'}
    end
  end

  def approve_ad
    if current_user.admin? && @ad.new?
      session[:return_to] ||= request.referer
      @ad.approve_ad
      redirect_to session.delete(:return_to), notice: 'ad was successfully approved.'
    else
      redirect_to admin_ads_path, :flash => {:error => 'ad can not approved.'}
    end
  end

  def ban_ad
    if current_user.admin? && @ad.new?
      session[:return_to] ||= request.referer
      @ad.reject_ad
      redirect_to session.delete(:return_to), notice: 'ad was successfully baned.'
    else
      redirect_to admin_ads_path, :flash => {:error => 'ad can not baned.'}
    end
  end

  def approve_ads
    @ads = Ad.find(params[:ad_ids])
    session[:return_to] ||= request.referer
    @ads.each do |ad|
      if ad.new?
        ad.approve_ad
      else
        redirect_to admin_ads_path, :flash => {:error => 'ad should be with status new!'} and return
      end
    end
    redirect_to session.delete(:return_to), notice: 'ads was successfully approved.'
  end

  private

  def ad_params
    params.require(:ad).permit(:title, :text, :price, :user_id, :ad_type_id, images_attributes: [:id, :file, :_destroy])
  end
end
