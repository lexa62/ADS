class AdsController < ApplicationController
  load_and_authorize_resource :except => [:index, :show]
  before_action :set_ad, only: [:show, :edit, :update, :destroy]

  def index
    @q = Ad.search(params[:q])
    @ads = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @ad = Ad.new
  end

  def edit
  end

  def create
    @ad = Ad.new(ad_params)
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

  def users_ads
    @q = current_user.ads.search(params[:q])
    @ads = @q.result(distinct: true).paginate(:page => params[:page], :per_page => 10)
  end

  def moderating
    @ad = Ad.find(params[:id])
      if @ad.user_id == current_user.id && @ad.draft?
        @ad.moderating
        redirect_to :my_ads, notice: 'ad was successfully published.'
      else
        redirect_to :my_ads, :flash => {:error => 'ad can not published.'}
      end
  end

  def make_draft
    @ad = Ad.find(params[:id])
      if @ad.user_id == current_user.id && @ad.archive?
        @ad.make_draft
        redirect_to :my_ads, notice: 'ad was successfully move in drafts.'
      else
        redirect_to :my_ads, :flash => {:error => 'ad can not moved in drafts.'}
      end
  end

  def edit_rejected_ad
    @ad = Ad.find(params[:id])
      if @ad.user_id == current_user.id && @ad.rejected?
        @ad.edit_rejected_ad
        redirect_to :my_ads, notice: 'ad was successfully moved in drafts.'
      else
        redirect_to :my_ads, :flash => {:error => 'ad can not moved in drafts.'}
      end
  end

  private
    def set_ad
      @ad = Ad.find(params[:id])
    end

    def ad_params
      params.require(:ad).permit(:title, :text, :price, :ad_type_id)
    end
end
