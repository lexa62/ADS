class AdTypesController < ApplicationController
  load_and_authorize_resource

  def new
    @ad_type = AdType.new
  end

  def create
    @ad_type = AdType.new(ad_type_params)

    respond_to do |format|
      if @ad_type.save
        format.html { redirect_to ad_types_url, notice: 'type was successfully created.' }
        format.json { render 'admin#ad_types', status: :created, location: ad_types_url }
      else
        format.html { render :new }
        format.json { render json: @ad_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ad_type.destroy
    respond_to do |format|
      format.html { redirect_to ad_types_url, notice: 'type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def ad_type_params
    params.require(:ad_type).permit(:name)
  end
end
