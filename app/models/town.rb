class Town < ApplicationRecord

  has_many  :hotels, dependent: :destroy
  has_many  :cafebars, dependent: :destroy
  has_many  :points, dependent: :destroy
  has_many  :category_counters, dependent: :destroy

  has_and_belongs_to_many :services
  has_and_belongs_to_many :actives

  has_rich_text :description

  default_scope { order(:number) }

  mount_uploader  :avatar, PictureUploader

  validates :name, :parent_name, :number, :avatar, presence: true
  
  validate  :avatar_size

  def avatar_for_cat(resources, resource_cat_id)
    # определяем имя ресурса в единственном числе
    resource = resources.delete_suffix("s")
    # производим выборку ресурсов города с определённой категорией
    resources = self.send(resources).where("#{resource}_category_id = ?", resource_cat_id)    
    # если объекты такой категории есть - выводим аватарку первого из них
    # если объектов нет - то выводим аватарку города
    #TODO: В выводе аватарок категорий объектов реализовать вывод только категорий имеющих объекты
    if resources.any?
      resources.first.avatar.thumb.url
    else
      avatar.thumb.url
    end   
  end

  private

  # Проверяем главное изображение города на размер
  def avatar_size    
    errors.add(:avatar, "- изображение должно быть меньше 4 МБ") if avatar.size > 4.megabytes
  end

end
