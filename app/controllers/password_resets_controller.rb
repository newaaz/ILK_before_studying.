class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Инструкция по восстановлению пароля отправлена на указанный почтовый адрес"
      redirect_to root_url
    else
      flash.now[:danger] = "Указанный почтовый ящик не найден"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      flash.now[:info] = "Пароль не может быть пустым"
      render 'edit'
    elsif @user.update(user_params)
      @user.update_attribute(:reset_digest, nil)
      reset_session
      log_in @user      
      flash[:info] = "Пароль был успешно изменён"
      redirect_to @user
    else
      render 'edit'
    end
  end

private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Подтверждает валидность пользователя для смены пароля
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      flash[:info] = "Не валидный пользователь"
      redirect_to root_url
    end
  end

  # Проверяет срок действия токена
  def check_expiration
    if @user.password_reset_expired?
      flash[:info] = "Срок сброса пароля истёк. Запросите сброс пароля повторно"
      redirect_to new_password_reset_url
    end
  end

end
