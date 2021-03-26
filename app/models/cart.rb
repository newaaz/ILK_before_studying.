class Cart < ApplicationRecord

  has_many :line_items, dependent: :destroy

  def hotels
    array_hotel_ids = []
    line_items.where('resource_name = ?', 'Hotel').each do |line_item|
      array_hotel_ids << line_item.resource_id
    end
    hotels = Hotel.find(array_hotel_ids)
  end

  def cafebars    
    array_cafebar_ids = []
    line_items.where('resource_name = ?', 'Cafebar').each do |line_item|
      array_cafebar_ids << line_item.resource_id
    end
    cafebars = Cafebar.find(array_cafebar_ids)
  end

end


