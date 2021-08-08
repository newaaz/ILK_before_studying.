class TownsController < ApplicationController

  before_action :user_admin, except: [:show, :hotels, :cafebars, :points, :services, :actives]

  def index
    @towns = Town.all    
  end
  
  def show
    @town = Town.find(params[:id])
    # счётчик всех категорий
    @town_cats = @town.category_counters
    # рекламные активности
    @promo_actives = @town.actives.activated.select(:id, :avatar, :name, :price).where("promouted = ?", 10).take(6)
    
    #рекламные Cafebars
    @promo_cafebars = @town.cafebars.activated.select(:id, :avatar, :name, :desc_json).where("rating = ?", 14).take(3)
    
    # категории достопримечательностей имеющие объекты
    @point_cats = @town_cats.where(cat_type: 'points')

    # Определяем существующие категории сервисов
    service_array_ids = []
    @town_cats.where(cat_type: 'services').each do |counter|
      service_array_ids << counter.cat_id
    end
    @service_cats = ServiceCategory.find(service_array_ids)

  end
  
  def new
    @town_new = Town.new
  end

  def create
    @town = Town.new(town_params)
    if @town.save
      flash[:success] = "Город успешно создан"
      redirect_to @town
    else
      render 'new'
    end
  end

  def edit
    @town = Town.find(params[:id])
  end

  def update
    @town = Town.find(params[:id])
    if @town.update(town_params)
      redirect_to town_path
      flash[:info] = 'Город успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить город'
      render :edit
    end
  end

  def destroy
    @town = Town.find(params[:id])
    @town.destroy
    flash[:info] = 'Город удалён'
    redirect_to towns_path
  end

  # Метод выводит всё жильё принадлежащее городу
  def hotels
    @town = Town.find(params[:id])

    # @hotel_categories = HotelCategory.all
    # определяем категории через счётчик
    #TODO: реализовать вывод категорий имеющих только активированные ресурсы
    @hotel_categories = @town.category_counters.where(cat_type: 'hotels')

    if params[:cat].blank?
      @hotels = @town.hotels.activated.select(:id, :avatar, :images, :name, :price_from, :distance_to_sea, :desc_json, :address)
    else
      @hotels = @town.hotels.activated.select(:id, :avatar, :images, :name, :price_from, :distance_to_sea, :desc_json, :address).where(hotel_category: params[:cat].to_i)
      @hotels_cat = HotelCategory.find(params[:cat].to_i).name
    end

    # определяем массив запомненных ID отелей, если есть @cart
    if @cart
      @array_resources_ids = []
      @cart.line_items.where(resource_name: "Hotel").each do |line_item|
        @array_resources_ids << line_item.resource_id
      end
    end
  end
  
  # Метод выводит все кафе принадлежащие городу
  def cafebars
    #  @town = Town.includes(:cafebars).find(params[:id])       ЧЕРЕЗ INCLUDES (потом проверить)
    @town = Town.find(params[:id])
    @tagcafebars = Tagcafebar.all   
    if params[:tag].blank?
      @cafebars = @town.cafebars.activated.select(:id, :avatar, :images, :name, :desc_json, :address)
    else
      @tag = Tagcafebar.find(params[:tag].to_i)
      @cafebars = @tag.cafebars.activated.select(:id, :avatar, :images, :name, :desc_json, :address).where(town_id: @town.id)

      # OPTIMIZE: проверить как делать такую выборку, для оптимизации запроса. Чтобы поиск происходил из кафешек города, а не из всех 
      # @cafebars = @town.cafebars.where(tagcafebar_ids: params[:tag].to_i)

    end 

    # определяем массив запомненных ID кафе, если есть @cart
    if @cart
      @array_resources_ids = []
      @cart.line_items.where(resource_name: "Cafebar").each do |line_item|
        @array_resources_ids << line_item.resource_id
      end
    end

  end

  # Метод выводит все Points (места, достопримечательности)
  def points    
    @town = Town.find(params[:id])
    # @point_categories = PointCategory.all
    # определяем категории через счётчик
    #TODO: реализовать вывод категорий имеющих только активированные ресурсы
    @point_categories = @town.category_counters.where(cat_type: 'points')
    
    if params[:cat].blank?
      @points = @town.points.activated.select(:id, :avatar, :images, :name, :desc_json)
    else
      @points = @town.points.activated.select(:id, :avatar, :images, :name, :desc_json).where(point_category: params[:cat].to_i)
      @points_cat = PointCategory.find(params[:cat].to_i).name
    end

    # определяем массив запомненных ID Points, если есть @cart
    if @cart
      @array_resources_ids = []
      @cart.line_items.where(resource_name: "Point").each do |line_item|
        @array_resources_ids << line_item.resource_id
      end
    end
  end

  # Метод выводит Услуги/Сервисы (Services)
  def services    
    @town = Town.find(params[:id])
    # @service_categories = ServiceCategory.all
    # определяем категории через счётчик
    #TODO: реализовать вывод категорий имеющих только активированные ресурсы
    @service_categories = @town.category_counters.where(cat_type: 'services')
    if params[:cat].blank?
      @services = @town.services.activated.select(:id, :avatar, :images, :name, :desc_json)
    else
      @services = @town.services.activated.select(:id, :avatar, :images, :name, :desc_json).where(service_category: params[:cat].to_i)
      @services_cat = ServiceCategory.find(params[:cat].to_i).name
    end

    # определяем массив запомненных ID Services, если есть @cart
    if @cart
      @array_resources_ids = []
      @cart.line_items.where(resource_name: "Service").each do |line_item|
        @array_resources_ids << line_item.resource_id
      end
    end
  end

  # Выводим активности города
  def actives
    @town = Town.find(params[:id])
    # @active_categories = ActiveCategory.all
    # определяем категории через счётчик
    #TODO: реализовать вывод категорий имеющих только активированные ресурсы
    @active_categories = @town.category_counters.where(cat_type: 'actives')   

    # вывод с категориями
    if params[:cat].blank?
      @actives = @town.actives.activated.select(:id, :avatar, :images, :name, :price, :desc_json)
    else
      @actives = @town.actives.activated.select(:id, :avatar, :images, :name, :price, :desc_json).where(active_category: params[:cat].to_i)
      @actives_cat = ActiveCategory.find(params[:cat].to_i).name
    end

    # определяем массив запомненных ID Actives, если есть @cart
    if @cart
      @array_resources_ids = []
      @cart.line_items.where(resource_name: "Active").each do |line_item|
        @array_resources_ids << line_item.resource_id
      end
    end
  end

  private

  def town_params
    params.require(:town).permit(:name, :parent_name, :number, :avatar)
  end

  def user_admin
    redirect_to root_path unless current_user && current_user.admin?
  end
  
  
end
