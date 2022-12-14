module SessionsHelper

  # Осуществляет вход данного пользователя
  def log_in(user)
    session[:user_id] = user.id
  end

  # Запоминает юзера в постоянном сеансе с помощью cookies
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Закрывает постоянный сеанс, user.forget определена в модели User
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Возвращает текущего вошедшего пользователя (если есть)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Возвращает true если посетитель авторизован, иначе false
  def logged_in?
    !current_user.nil?
  end
  # Осуществляет выход текущего пользователя
  def log_out
    forget(current_user)
    #session.delete(:user_id)
    reset_session # сбрасывает всю сессию
    @current_user = nil
  end

  # проверяет евляется ли пользователь полученный из: params[:id] текущим пользователем
  def current_user?(user)
    user && user == current_user
  end

  # Запоминает URL
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
