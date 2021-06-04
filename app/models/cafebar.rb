class Cafebar < ApplicationRecord

  belongs_to :user
  belongs_to :town

  has_and_belongs_to_many :tagcafebars

  has_rich_text :description
  has_rich_text :menu

  mount_uploader  :avatar, PictureUploader
  mount_uploaders :images, PictureUploader

  validates :name, :address, :avatar, :description, :menu, presence: true

  validate  :avatar_type_size
  validate  :image_type_size
  validate  :coordinates
  validate  :description_embeds
  validate  :menu_embeds

private

  # Проверяем главное изображение Avatar carrierwave
  def avatar_type_size
    # эта проверка на тип файла проверяется самим загрузчиком
    #errors.add(:avatar, "должно иметь формат JPEG или PNG") unless avatar.content_type.in?(%('image/jpeg image/png'))
    
    # проверка размера файла
    errors.add(:avatar, "- изображение должно быть меньше 4 МБ") if avatar.size > 4.megabytes
  end

  # Проверяем прикреплённые файлы carrierwave
  def image_type_size
    #@max_byte_size = 5.megabytes
    errors.add(:images, "- общее количество - не больше 35 фотографий") if images.count > 35
    if images.any?
      images.each do |image|
        # проверки для ActiveStorage
        #errors.add(:images, "должны содержать только изображения или фотографии") unless image.image?
        #errors.add(:images, "должны иметь формат JPEG или PNG") unless image.content_type.in?(%('image/jpeg image/png'))
        
        errors.add(:images, "- одно или несколько изображений превышают допустимый размер - 4 МБ") if image.size > 4.megabytes
      end   
    end
  end  

  # Проверяем прикрепленные файлы Action Text'a :description
  def description_embeds 
    #@max_byte_size = 5.megabytes
    @attachments = rich_text_description.body.attachments
    if @attachments.any?
      errors.add(:description, 'Нельзя загружать более 20 изображений') if @attachments.size > 20
      @attachments.each do |attach|
        errors.add(:description, ' - одно из используемых в тексте изображений больше 3МБ') if attach.byte_size > 3.megabytes
        errors.add(:description, 'можно загружать только изображения') unless attach.image? 
        errors.add(:description, "должно содержать только изображения формата JPG или PNG") unless attach.content_type.in?(%('image/jpeg image/png'))
      end
    end
  end

  # Проверяем прикреплённые файлы Action Text'a :menu
  def menu_embeds 
    #@max_byte_size = 5.megabytes
    @attachments = rich_text_menu.body.attachments
    if @attachments.any?
      errors.add(:menu, 'Нельзя загружать более 20 изображений') if @attachments.size > 20
      @attachments.each do |attach|
        errors.add(:menu, ' - одно из используемых в тексте изображений больше 3МБ') if attach.byte_size > 3.megabytes
        errors.add(:menu, 'можно загружать только изображения') unless attach.image? 
        errors.add(:menu, "должно содержать только изображения формата JPG или PNG") unless attach.content_type.in?(%('image/jpeg image/png'))
      end
    end
  end

  def coordinates
    errors.add(:latitude, 'Нужно отметить объект на карте') if latitude.nil? || longitude.nil?
  end

end
