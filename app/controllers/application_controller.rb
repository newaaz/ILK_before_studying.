class ApplicationController < ActionController::Base

  include CurrentCart
  before_action :find_cart

  include SessionsHelper
  include Pagy::Backend

  def change_activated
    #TODO: реализовать общую проверку админовских методов
    redirect_to root_url unless current_user.admin

    model = params[:model].constantize
    object = model.find(params[:id].to_i)
    object.toggle!(:activated)
   

    # определяем куда перенаправлять
    resources_path = (params[:model].downcase + 's').to_sym
    redirect_back(fallback_location: resources_path)

    # посылаем письмо юзеру об активации
    #TODO: потом включить письмо юзеру об активации
    #UserMailer.change_activated(object).deliver_now if object.activated?
  end

  def change_rating
    #TODO: реализовать общую проверку админовских методов
    redirect_to root_url unless current_user.admin   
    model = params[:model].constantize
    object = model.find(params[:id].to_i)
    object.update_column(:rating, params[:rating].to_i)

    # определяем куда перенаправлять
    resources_path = (params[:model].downcase + 's').to_sym
    redirect_back(fallback_location: resources_path)    
  end

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
