class Room < ApplicationRecord
  
  belongs_to :hotel

  has_many  :prices, dependent: :destroy
  accepts_nested_attributes_for :prices, reject_if: :all_blank, allow_destroy: true
  
  mount_uploader  :avatar, PictureUploader
  mount_uploaders :images, PictureUploader

  validates :avatar, :hotel_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  #validates :size, numericality: { allow_nil: true }
  validates :number, :size, numericality: { greater_than: 0, less_than: 9999 }

  validate  :avatar_type_size
  validate  :image_type_size   

  after_save  :set_min_price!


private

  # Проверяем главное изображение Avatar через carrierwave
  def avatar_type_size    
    errors.add(:avatar, "- изображение должно быть меньше 4 МБ") if avatar.size > 4.megabytes
  end

  # Проверяем прикреплённые файлы carrierwave
  def image_type_size
    #@max_byte_size = 5.megabytes
    errors.add(:images, "- общее количество - не больше 15 фотографий") if images.count > 15
    if images.any?
      images.each do |image|
        # проверки для ActiveStorage
        #errors.add(:images, "должны содержать только изображения или фотографии") unless image.image?
        #errors.add(:images, "должны иметь формат JPEG или PNG") unless image.content_type.in?(%('image/jpeg image/png'))
        
        errors.add(:images, "- одно или несколько изображений превышают допустимый размер - 4 МБ") if image.size > 4.megabytes
      end   
    end
  end

  # Устанавливаем минимальную цену после сохранения
  def set_min_price!
    min_price = prices.minimum(:day_cost)
    description['min_price'] = min_price
    desc_new = description
    update_column(:description, desc_new)    
  end

end
