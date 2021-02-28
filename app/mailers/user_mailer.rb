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

  # Отправляем админу уведомление, что новый пользователь активировал аккаунт
  # account_activation/edit
  def account_activation_admins(user)
    @user = user
    mail to: "ilk-ui@ya.ru", subject: "Пользователь: #{@user.email} активирован"
  end

    # Отправляем владельцу жилья уведомление, что у него появилась новая заявка
    # Orders/create
  def owner_user_reservation(order)
    @order = order
    mail to: @order.owner_user.email, subject: "Заявка на бронирование № #{@order.id}. Отправитель: #{@order.guest_name}"
  end

  # Отправляем забронировавшему клиенту уведомление, что его заявка отправлена и администраторы гостиницы свяжутся с ним
  # Orders/create
  def guest_reservation(order)
    @order = order
    mail to: @order.guest_email, subject: "Спасибо за бронирование через наш сервис"
  end


  
end
