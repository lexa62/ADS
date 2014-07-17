module Admin
  class UsersController < BaseController
    load_and_authorize_resource

    def index
      @users = User.paginate(:page => params[:page], :per_page => 10)
    end

    def new
      @user.build_avatar
    end

    def edit
    end

    def create
      respond_to do |format|
        if @user.save
          format.html { redirect_to admin_user_path(@user), notice: 'user was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to admin_user_path(@user), notice: 'user was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_url, notice: 'user was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role, avatar_attributes: [:id, :file, :_destroy])
    end
  end
end
