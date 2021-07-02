# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Добавляем типы жилья
HotelCategory.destroy_all
HotelCategory.create(name: "Гостевые дома", number: 1)
HotelCategory.create(name: "Гостиницы", number: 2)
HotelCategory.create(name: "Отели", number: 3)
HotelCategory.create(name: "Квартиры", number: 4)
HotelCategory.create(name: "Дома под ключ", number: 5)
HotelCategory.create(name: "Частный сектор", number: 6)
HotelCategory.create(name: "Эллинги", number: 7)
HotelCategory.create(name: "Пансионаты", number: 8)
HotelCategory.create(name: "Бюджетное жильё", number: 9)
HotelCategory.create(name: "Другое", number: 10)
# Town.destroy_all



