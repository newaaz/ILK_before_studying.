class HotelCategory < ApplicationRecord

  default_scope { order(:number) }

  validates :name, presence: true
  
end
