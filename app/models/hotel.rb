class Hotel < ApplicationRecord

  belongs_to  :user
  belongs_to  :town
  belongs_to  :hotel_category
  has_many    :rooms, dependent: :destroy
  has_many    :orders, dependent: :destroy

  has_rich_text :description

  mount_uploader  :avatar, PictureUploader
  mount_uploaders :images, PictureUploader

  validates :name, :price_from, :avatar, :latitude, :longitude, :description, presence: true

  # validate email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255, minimum: 6},
                    format: {with: VALID_EMAIL_REGEX}

  validates :price_from, numericality: { greater_than: 0, less_than: 999999 }
  validates :distance_to_sea, numericality: { allow_nil: true, greater_than: 0, less_than: 30000 }

  validate  :avatar_type_size 
  validate  :image_type_size

  validate  :description_embeds

  validate  :check_desc_json

  before_save :downcase_email # переводим указанную почту в нижний регистр

  after_save  :set_town_name!

  after_create  :set_town_category_counter

  scope :activated, -> { where(activated: true) }

private

  # Проверяем главное изображение Avatar загруженное через carrierwave
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
    errors.add(:description, " - слишком длинное (не более 4000 символов)") if description.to_plain_text.size > 4000
  end

  # проверка JSON описания объекта
  def check_desc_json
    desc_json.each do |desc_item|
      errors.add(desc_item[0],' - описание слишком длинное (не более 255 символов)') if desc_item[1].size > 255
    end
  end

  # добавляем в город счётчик категорий
  def set_town_category_counter
    counter = town.category_counters.where(cat_type: 'hotels', cat_id: hotel_category.id).first

    if counter
      counter.update_column(:cat_count, counter.cat_count+1)
    else
      counter = town.category_counters.build(cat_type: 'hotels', cat_id: hotel_category.id, cat_name: hotel_category.name )
      counter.save
    end
  end

  # Устанавливаем название города в JSON-описание отеля
  def set_town_name!
    desc_json['town_name'] = town.name
    desc_json['town_parent_name'] = town.parent_name
    desc_json['cat_name'] = hotel_category.name  
    update_column(:desc_json, desc_json)  
  end

  # Преобразует емаил в нижний регистр
  def downcase_email
    self.email = email.downcase
  end

end
