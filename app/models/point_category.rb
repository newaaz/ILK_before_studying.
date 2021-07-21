class PointCategory < ApplicationRecord

  has_many  :points, dependent: :destroy

  default_scope { order(:number) }

  # mount_uploader  :avatar, PictureUploader

  validates :name, presence: true

end
