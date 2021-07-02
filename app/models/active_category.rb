class ActiveCategory < ApplicationRecord
  
  has_many  :actives, dependent: :destroy

  default_scope { order(:number) }

  #mount_uploader  :avatar, PictureUploader

  validates :name, presence: true
end
