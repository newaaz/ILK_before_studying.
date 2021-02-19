module ApplicationHelper

  include Pagy::Frontend

  # Определяет title, если значения нет подставляет базовое
  # в главном макете страницы
  def full_title(page_title = '')
    base_title = "Люблю Крым!"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

end
