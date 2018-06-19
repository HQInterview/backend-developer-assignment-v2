class UsersController < ApplicationController

  skip_before_action :require_login, only: [:new, :create, :activate, :new_act_email, :send_act_email, :new_session, :create_session, :destroy_session, :new_reset_password, :create_reset_password, :edit_password, :update_password]

  # User Registration
  #--------------------------------------------------------------
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to login_path, notice: "Registration successfull. Check your email for activation instructions."
    else
      render :action => "new"
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      redirect_to login_path, notice: "User was successfully activated."
    else
      not_authenticated
    end
  end

  # User Sessions (login/logout)
  #--------------------------------------------------------------
  def new_session
  end

  def create_session
    if @user = login(params[:email], params[:password], params[:remember])
      redirect_to root_path, notice: "Login successfull."
    else
      flash.now[:alert] = "Login Failed!"; render action: "new_session"
    end
  end

  def destroy_session
    logout
    redirect_to root_path, notice: "Logged out!"
  end

  # Reset password
  #--------------------------------------------------------------
  def new_reset_password
  end

  def create_reset_password
    if user = User.find_by_email(params[:email])
      user.deliver_reset_password_instructions!
      redirect_to root_path, notice: "Instructions have been sent to your email."
    else
      flash.now[:alert] = "User does not exist."; render action: "new_reset_password"
    end
  end

  def edit_password
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    not_authenticated if !@user
  end

  def update_password
    @token = params[:token]
    @user = User.load_from_reset_password_token @token
    not_authenticated if !@user
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password! params[:user][:password]
      redirect_to login_path, notice: "Password was successfully updated."
    else
      render action: "edit_password"
    end
  end

  # Resend User Activation email
  #--------------------------------------------------------------
  def new_act_email
  end

  def send_act_email
    if user = User.find_by_email(params[:email])
      if user.active?
        redirect_to login_path, notice: "User is already Active. No need to resend activation email."
      else
        user.resend_activation_email!
        redirect_to root_path, notice: "Activation email resend. Check your email for instructions."
      end
    else
      flash.now[:alert] = "User does not exist."; render action: "new_act_email"
    end
  end


private

  # Generate strong parameters for user
  def user_params
    params.require(:user).permit :email, :password, :password_confirmation
  end

end
