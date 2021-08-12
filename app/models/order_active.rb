class OrderActive < ApplicationRecord

  attr_accessor :owner_user

  belongs_to :active

  before_create :downcase_guest_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :guest_email, presence: true, length: {maximum: 255, minimum: 6},
                    format: {with: VALID_EMAIL_REGEX}
  validates :guest_name, :guest_phone, presence: true

  # определяем владельца жилья к которому создана заявка (для писем-уведомлений о бронировании)
  def owner_user    
    self.owner_user = self.active.user
  end

private

  def downcase_guest_email
    self.guest_email = guest_email.downcase
  end


end
