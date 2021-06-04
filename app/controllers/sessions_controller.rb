class SessionsController < ApplicationController

  layout 'clean'

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        forwarding_url = session[:forwarding_url] # Если пришли с метода logged_in_user
        reset_session   # сброс сеанса перед входом в систему
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user      
        redirect_to forwarding_url || user
      else
        message =  "Учётная запись не активирована"
        message += "Проверьте почту для активации"
        flash[:info] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Неправильный email или пароль"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
