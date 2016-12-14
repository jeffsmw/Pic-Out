class UsersController < ApplicationController
  # before_action :authenticate_user, only: [:index]
  def new
    @user = User.new
    respond_to do |format|
      format.js { render :new }
      format.html {render :new }
    end
  end

  def create
    user_params = params.require(:user).permit(:first_name,
                                               :last_name,
                                               :email,
                                               :password,
                                               :password_confirmation)
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, notice: 'Thanks for signing up'
    else
      flash.now[:alert] = 'Please make sure all fields are filled in'
      render :new
    end
  end

  def show
    @user = current_user
    respond_to do |format|
      format.js { render :show }
      format.html { render :show }
    end
  end

  def edit
    @user = current_user
    respond_to do |format|
      format.js { render :edit }
      format.html { render :edit }
    end
  end

  def update
    @user = User.find params[:id]
    user_params = params.require(:user).permit(:first_name,
                                               :last_name,
                                               :email,
                                               :password,
                                               :password_confirmation)

    @user.update user_params
    respond_to do |format|
      format.js { render :show }
      format.html { render :show }
    end
    # if @user.update user_params
    #   redirect_to user_path(@user), notice: 'Your profile has been updated'
    # else
    #   flash.now[:alert] = 'Your profile was not updated. Fix these errors'
    #   render :edit
    # end
  end

  def index
    @user = User.all
  end
end
