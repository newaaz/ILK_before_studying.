module ApplicationHelper

  include Pagy::Frontend

  # Определяет title, если значения нет подставляет базовое
  # в главном макете страницы
  def full_title(page_title = '')
    base_title = "Люблю Крым!"
    if page_title.empty?
      base_title
    else
      # page_title + " | " + base_title
      page_title
    end
  end

   # Вычисляем расстояние между двумя метками, переводим в метры и округляем
  def distance_between(obj1, obj2)
    (120000 * Math.sqrt((obj2.latitude - obj1.latitude)**2 + (obj2.longitude - obj1.longitude)**2)).floor(-1)
  end

  # Возвращает соседние отели
  def hotels_near(resource)
  min_lat = resource.latitude - 0.0090
  max_lat = resource.latitude + 0.0090
  min_long = resource.longitude - 0.0127
  max_long = resource.longitude + 0.0127    
  hotels = resource.town.hotels
  hotels.where(latitude: min_lat..max_lat, longitude: min_long..max_long).where.not(id: resource.id)
  end

  # Возвращает соседние кафе, кроме его самого
  def cafebars_near(resource)
    min_lat = resource.latitude - 0.0090
    max_lat = resource.latitude + 0.0090
    min_long = resource.longitude - 0.0127
    max_long = resource.longitude + 0.0128
    cafebars = resource.town.cafebars
    cafebars.where(latitude: min_lat..max_lat, longitude: min_long..max_long).where.not(id: resource.id)
  end

  # Возвращаем соседние ресурсы (resources) с источником (source)
  def resources_near(source, resources)
    min_lat = source.latitude - 0.0090
    max_lat = source.latitude + 0.0090
    min_long = source.longitude - 0.0127
    max_long = source.longitude + 0.0128
    objects = source.town.send(resources).where(latitude: min_lat..max_lat, longitude: min_long..max_long).where.not(id: source.id)
  end

end
