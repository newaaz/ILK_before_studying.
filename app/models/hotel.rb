class Hotel < ApplicationRecord

  belongs_to  :user
  belongs_to  :town
  belongs_to  :hotel_category  
  has_many    :rooms, dependent: :destroy
  has_many    :orders, dependent: :destroy

  mount_uploader  :avatar, PictureUploader
  mount_uploaders :images, PictureUploader

  validates :name, :price_from, :avatar, :latitude, :longitude, presence: true

  validates :price_from, numericality: { greater_than: 0 }
  validates :distance_to_sea, numericality: { allow_nil: true, greater_than: 0 }

  validate  :avatar_type_size
  validate  :image_type_size

private

  # Проверяем главное изображение Avatar через carrierwave
  def avatar_type_size
    # эта проверка на тип файла проверяется самим загрузчиком
    #errors.add(:avatar, "должно иметь формат JPEG или PNG") unless avatar.content_type.in?(%('image/jpeg image/png'))
    
    # проверка размера файла
    errors.add(:avatar, "- изображение должно быть меньше 4 МБ") if avatar.size > 4.megabytes
  end

  # Проверяем прикреплённые фото через carrierwave
  def image_type_size
    #@max_byte_size = 5.megabytes
    errors.add(:images, "- общее количество - не больше 35 фотографий") if images.count > 35
    if images.any?
      images.each do |image|        
        errors.add(:images, "- одно или несколько изображений превышают допустимый размер - 4 МБ") if image.size > 4.megabytes
      end   
    end
  end  

  # Проверяем прикрепленные файлы Action Text'a
  def description_embeds 
    #@max_byte_size = 5.megabytes
    @attachments = rich_text_description.body.attachments
    if @attachments.any?
      errors.add(:description, 'Нельзя загружать более 10 изображений') if @attachments.size > 10
      @attachments.each do |attach|
        errors.add(:description, ' - одно из используемых в тексте изображений больше 3МБ') if attach.byte_size > 3.megabytes
        errors.add(:description, 'Можно загружать только изображения') unless attach.image? 
        errors.add(:description, "должно содержать только изображения формата JPG или PNG") unless attach.content_type.in?(%('image/jpeg image/png'))
      end
    end
  end

  def coordinates
    errors.add(:latitude, 'Нужно отметить объект на карте') if latitude == 0 || longitude == 0
  end

end
