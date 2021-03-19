class ApplicationController < ActionController::Base

  include CurrentCart
  before_action :find_cart

  include SessionsHelper
  include Pagy::Backend

private

  # Перенесли из UsersController
  # Подтверждает вход пользователя
  def logged_in_user
    unless logged_in?
      store_location
      flash[:info] = "Пожалуйста, авторизуйтесь."
      redirect_to login_url
    end
  end

end
