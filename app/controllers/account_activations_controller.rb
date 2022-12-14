class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_columns(activated: true, activated_at: Time.zone.now)
      # отправляем админу письмо об активации аккаунта нового пользователя
      UserMailer.account_activation_admins(user).deliver_now 
      #log_in user (после активации перенаправляем на страницу входа, а не авторизовываем сразу)
      flash[:success] = "Учётная запись успешно активирована. Для входа в систему используйте e-mail и пароль указанные при регистрации"
      redirect_to login_url
    else
      flash[:info] = "Некорректная ссылка активации"
      redirect_to root_url
    end
  end

end
