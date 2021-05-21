class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:create, :edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_path
    else
      flash.now[:danger] = "Email address not found"
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render :edit
    elsif @user.update(user_params)
      @user.forget
      reset_session
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render :edit
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user
      if action_name == "create"
        @user = User.find_by(email: params[:password_reset][:email].downcase)
      else
        @user = User.find_by(email: params[:email])
      end
    end
    
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_path
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_path
      end
    end
end
