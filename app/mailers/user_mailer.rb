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
  def owner_reservation(order)
    @order = order
    mail to: @order.hotel.email, subject: "Люблю Крым | Заявка на бронирование № #{@order.id}. Отправитель: #{@order.guest_name}"
  end
  # Отправляем забронировавшему клиенту уведомление, что его заявка отправлена и администраторы гостиницы свяжутся с ним
  # Orders/create
  def guest_reservation(order)
    @order = order
    mail to: @order.guest_email, subject: "Спасибо за бронирование через наш сервис"
  end

  # Отправляем владельцу Активности о новой заявке
  # order_actives/create
  def active_reservation_owner(order)
    @order = order
    mail to: @order.owner_user.email, subject: "Люблю Крым | Новая заявка № #{@order.id}. Отправитель: #{@order.guest_name}"
  end
  # Отправляем клиенту уведомление что его заявка отправлена
  def active_reservation_guest(order)
    @order = order
    @active = order.active
    mail to: @order.guest_email, subject: "Спасибо за бронирование через наш сервис"
  end

  # Отправляем админу письмо о создании ресурса
  def resource_create(resource)
    @resource = resource
    #TODO: Изменить почту админа
    mail to: "ilk-ui@ya.ru", subject: "#{@resource.model_name.name}:#{@resource.name} создан"
  end

  # Отправляем письмо когда ресурс активирован (универсальный для всех ресурсов)
  def change_activated(resource)
    @resource = resource
    mail to: @resource.user.email, subject: "#{@resource.name} - страница активирована и опубликована"
  end

  # Отправляем владельцу жилья письмо о том что ему пришло сообщение (как-то так...)
  def send_message_owner(message_hash)     

    @message_hash = message_hash

    @room = Room.find(message_hash["room_id"]).name if message_hash["room_id"] != 0  

    mail to: @message_hash["hotel_email"], subject: "Вам пришло сообщение c сайта 'Люблю Крым'"
  end
  
end
