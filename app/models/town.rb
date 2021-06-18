class Town < ApplicationRecord

  has_many  :hotels, dependent: :destroy
  has_many  :cafebars, dependent: :destroy
  has_many  :points, dependent: :destroy

  has_and_belongs_to_many :services

  default_scope { order(:number) }

  mount_uploader  :avatar, PictureUploader

  validates :name, :parent_name, :number, :avatar, presence: true
  
  validate  :avatar_size

  private

  # Проверяем главное изображение города на размер
  def avatar_size    
    errors.add(:avatar, "- изображение должно быть меньше 4 МБ") if avatar.size > 4.megabytes
  end

end
