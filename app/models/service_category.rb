class ServiceCategory < ApplicationRecord

  has_many  :services, dependent: :destroy

  default_scope { order(:number) }

  mount_uploader  :avatar, PictureUploader

  validates :name, presence: true

end
