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
# PointCategory.create(name: "Стадионы", number: 9)

# Добавляем категории Услуг и Сервисов
ServiceCategory.destroy_all
ServiceCategory.create(name: "Доставка еды", avatar: "icon_set_1_icon-14", number: 1)
ServiceCategory.create(name: "Такси", avatar: "icon_set_1_icon-21", number: 2)
ServiceCategory.create(name: "Прокат авто", avatar: "icon-right-dir-1", number: 3)
ServiceCategory.create(name: "Спортзалы", avatar: "icon_set_2_icon-117", number: 4)
ServiceCategory.create(name: "Пляжи", avatar: "icon_set_2_icon-108", number: 4)
ServiceCategory.create(name: "Детские комнаты", avatar: "icon_set_1_icon-70", number: 5)
ServiceCategory.create(name: "Частные клиники", avatar: "icon-ambulance", number: 5)
ServiceCategory.create(name: "Ремонт телефонов", avatar: "icon-mobile-6", number: 9)

ServiceCategory.create(name: "Эвакуатор", avatar: "icon-right-dir-1", number: 9)
ServiceCategory.create(name: "Прачечные", avatar: "icon-right-dir-1", number: 9)
ServiceCategory.create(name: "Ремонт обуви", avatar: "icon-right-dir-1", number: 9)
ServiceCategory.create(name: "Теннис", avatar: "icon-right-dir-1", number: 9)
ServiceCategory.create(name: "Массаж", avatar: "icon-right-dir-1", number: 9)
ServiceCategory.create(name: "Бильярд", avatar: "icon-right-dir-1", number: 9)
ServiceCategory.create(name: "Бани / Сауны", avatar: "icon-right-dir-1", number: 9)
ServiceCategory.create(name: "Парикмахерские", avatar: "icon-right-dir-1", number: 9)


# Добавляем теги-категории Кафе-ресторанов
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

