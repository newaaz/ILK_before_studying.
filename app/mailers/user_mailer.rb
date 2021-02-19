class UserMailer < ApplicationMailer

  # Отправляем ссылку для активации пользователя при регистрации
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Активация аккаунта на сайте «Люблю Крым»"
  end

  # Отправляем ссылку на сброс пароля
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Восстановление пароля на сайте «Люблю Крым»"
  end
  
end
