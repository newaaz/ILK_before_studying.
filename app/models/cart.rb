class Cart < ApplicationRecord

  has_many :line_items, dependent: :destroy

  # find checked hotels
  def hotels
    array_hotel_ids = []
    line_items.where('resource_name = ?', 'Hotel').each do |line_item|
      array_hotel_ids << line_item.resource_id
    end
    Hotel.find(array_hotel_ids)
  end

  # find checked cafe
  def cafebars
    # edit with github online    
    array_cafebar_ids = []
    line_items.where('resource_name = ?', 'Cafebar').each do |line_item|
      array_cafebar_ids << line_item.resource_id
    end
    Cafebar.find(array_cafebar_ids)
  end

  # find checked points
  def points
    array_point_ids = []
    line_items.where('resource_name = ?', 'Point').each do |line_item|
      array_point_ids << line_item.resource_id
    end
    Point.find(array_point_ids)
  end

  # find checked services
  def services
    array_service_ids = []
    line_items.where('resource_name = ?', 'Service').each do |line_item|
      array_service_ids << line_item.resource_id
    end
    Service.find(array_service_ids)
  end

  # find checked actives
  def actives
    array_active_ids = []
    line_items.where('resource_name = ?', 'Active').each do |line_item|
      array_active_ids << line_item.resource_id
    end
    Active.find(array_active_ids)
  end

end


