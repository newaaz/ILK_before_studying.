class Room < ApplicationRecord
  
  belongs_to :hotel

  has_many  :prices, dependent: :destroy
  accepts_nested_attributes_for :prices, allow_destroy: true

  default_scope { order(:number) }


  #has_rich_text :description

  mount_uploaders :images, PictureUploader

  validates :hotel_id, :name, presence: true
  validates :size, numericality: { allow_nil: true }
  validates :number, numericality: { greater_than: 0 }

  validate  :image_type_size
  
  # проверка описания ActionText
  # validate  :description_embeds

private

  # Проверяем прикреплённые файлы carrierwave
  def image_type_size
    #@max_byte_size = 5.megabytes
    errors.add(:images, "- общее количество - не больше 20 фотографий") if images.count > 20
    if images.any?
      images.each do |image|
        # проверки для ActiveStorage
        #errors.add(:images, "должны содержать только изображения или фотографии") unless image.image?
        #errors.add(:images, "должны иметь формат JPEG или PNG") unless image.content_type.in?(%('image/jpeg image/png'))
        
        errors.add(:images, "- одно или несколько изображений превышают допустимый размер - 4 МБ") if image.size > 4.megabytes
      end   
    end
  end

  # Проверяем прикрепленные файлы Action Text'a
  def description_embeds 
    #@max_byte_size = 5.megabytes
    @attachments = rich_text_description.body.attachments
    if @attachments.any?
      errors.add(:description, 'Нельзя загружать более 2 изображений') if @attachments.size > 2
      @attachments.each do |attach|
        errors.add(:description, ' - одно из используемых в тексте изображений больше 3МБ') if attach.byte_size > 3.megabytes
        errors.add(:description, 'Можно загружать только изображения') unless attach.image? 
        errors.add(:description, "должно содержать только изображения формата JPG или PNG") unless attach.content_type.in?(%('image/jpeg image/png'))
      end
    end
  end

end