module Admin
  class AdTypesController < BaseController
    load_and_authorize_resource

    def index
      @ad_types = @ad_types.paginate(:page => params[:page], :per_page => 10)
    end

    def new
    end

    def create
      respond_to do |format|
        if @ad_type.save
          format.html { redirect_to admin_ad_types_url, notice: 'type was successfully created.' }
          format.json { render 'admin#ad_types', status: :created, location: admin_ad_types_url }
        else
          format.html { render :new }
          format.json { render json: @ad_type.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      if @ad_type.destroy
        message = 'type was successfully destroyed.'
      else
        message = 'type can not be destroyed'
      end

      respond_to do |format|
        format.html { redirect_to admin_ad_types_url, notice: message }
        format.json { head :no_content }
      end
    end

    private

    def ad_type_params
      params.require(:ad_type).permit(:name)
    end
  end
end
