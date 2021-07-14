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

# Добавляем типы Интересных Мест
PointCategory.destroy_all
PointCategory.create(name: "Пляжи", number: 1)
PointCategory.create(name: "Достопримечательности", number: 2)
PointCategory.create(name: "Парки", number: 3)
PointCategory.create(name: "Кинотеатры", number: 4)
PointCategory.create(name: "Музеи", number: 5)
PointCategory.create(name: "Театры", number: 6)
PointCategory.create(name: "Рынки", number: 7)
PointCategory.create(name: "Места для фото", number: 8)

# Добавляем категории Услуг и Сервисов
ServiceCategory.destroy_all
ServiceCategory.create(name: "Доставка еды", number: 1)
ServiceCategory.create(name: "Такси", number: 2)
ServiceCategory.create(name: "Прокат авто", number: 3)

# Добавляем категории Кафе-ресторанов
Tagcafebar.destroy_all
Tagcafebar.create(name: "Доставка еды")
Tagcafebar.create(name: "Суши")
Tagcafebar.create(name: "Кофе")
Tagcafebar.create(name: "Банкетный зал")

# Добавляем категории Активного отдыха
ActiveCategory.destroy_all
ActiveCategory.create(name: "Морские прогулки", number: 1)
ActiveCategory.create(name: "Воздушные прогулки", number: 2)
ActiveCategory.create(name: "Конные прогулки", number: 3)
ActiveCategory.create(name: "Мото прогулки", number: 4)
ActiveCategory.create(name: "Пешие экскурсии", number: 5)
ActiveCategory.create(name: "Горы", number: 6)
ActiveCategory.create(name: "Другое", number: 7)

