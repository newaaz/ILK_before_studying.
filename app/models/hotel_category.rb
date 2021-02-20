class HotelCategory < ApplicationRecord

  has_many :hotels, dependent: :destroy

  default_scope { order(:number) }

  validates :name, presence: true
  
end
