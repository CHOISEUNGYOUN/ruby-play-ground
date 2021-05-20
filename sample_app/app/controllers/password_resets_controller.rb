class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:create, :edit, :update]
  before_action :valid_user, only: [:edit, :update]

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
  
  private
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
    
end
