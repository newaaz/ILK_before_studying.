class User < ApplicationRecord

  attr_accessor :remember_token, :activation_token, :reset_token, :owner_orders

  has_many  :hotels, dependent: :destroy
  has_many  :cafebars, dependent: :destroy
  has_many  :points, dependent: :destroy
  has_many  :services, dependent: :destroy
  has_many  :actives, dependent: :destroy

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255, minimum: 6},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}
  
  validates :password, length: {minimum: 6 }, allow_nil: true

  has_secure_password

  #_______________ Методы ___________________

  # Возвращает заявки по отелям принадлежащим пользователю
  def owner_orders
    if hotels.any?
      self.owner_orders = Order.where(hotel_id: hotel_ids).order({updated_at: :desc}, :hotel_id)
    end
  end

  # Возвращает случайные токены для хранения куков для запоминания сеанса,
  # активации аккаунта и сброса пароля
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Возвращает дайджест (хэш) для указанной строки
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Запоминает юзера в БД для использования в постоянных сеансах
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Забываем пользователя (куки удаляются в Sessions_helper)
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Возвращает true, если полученный токен соответствует дайджесту
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Устанавливает атрибуты для сброса пароля
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Посылает письмо со ссылкой на форму ввода нового пароля
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Возвращает true если срок хранения пароля истёк
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

private

  # Преобразует емаил в нижний регистр
  def downcase_email
    self.email = email.downcase
  end

  # Создаёт и присваивает токен активации и его дайджест
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
