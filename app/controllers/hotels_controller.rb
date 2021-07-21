class HotelsController < ApplicationController  
  
  before_action :logged_in_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index    
    redirect_back(fallback_location: root_url) unless current_user && current_user.admin?  
    @hotels = Hotel.all.order(created_at: :desc)
  end
  
  def show
    @hotel = Hotel.includes(:rooms).references(:rooms).order(:number).find(params[:id])
    #TODO: рефакторить ВЕЗДЕ определение города включая счётчики категорий - @hotel.town.includes(:cat_counter)
    @town = @hotel.town
    
    # определяем - является ли этот отель запомненным    
    current_item = @cart.line_items.find_by(resource_id: params[:id], resource_name: 'Hotel') if @cart
    @current_item = true if current_item

    # подготавливаем строку к SEO-description
    if @hotel.distance_to_sea.blank?
      @seo_description = "От #{@hotel.price_from}руб. Жильё и активный отдых в Крыму на сайте Люблю Крым - ilovekrim.ru"
    else
      @seo_description = "От #{@hotel.price_from}руб. До моря #{@hotel.distance_to_sea}м. Жильё и активный отдых в Крыму на сайте Люблю Крым - ilovekrim.ru"
    end
    
  end
  
  def new
    @hotel = Hotel.new    
  end

  def create    
    @hotel = current_user.hotels.build(hotel_params)
    @hotel.desc_json = JSON.parse(params[:desc_json])
    if @hotel.save
      flash[:success] = "Объект успешно создан"
      redirect_to @hotel
    else
      render 'new'
    end
  end

  def edit
    @hotel = Hotel.find(params[:id])
  end

  def update
    @hotel = Hotel.find(params[:id])
    @hotel.desc_json = JSON.parse(params[:desc_json])
    # Category_name & Town_name - in model (after_save:)
    
    # запоминаем старое значение категории и города
    old_cat = @hotel.hotel_category.id
    old_town = @hotel.town.id


    if @hotel.update(hotel_params)

      # сравниваем старые и новые значения после обновления
      if old_cat != @hotel.hotel_category.id || old_town != @hotel.town.id  # или params[:town_id] - так запроса к БД не будет
        
        # находим старую запись счётчика и меняем её (или вообще удаляем)
        counter = Town.find(old_town).category_counters.where(cat_type: 'hotels', cat_id: old_cat).first
        if counter.cat_count == 1
          counter.destroy
        else
          counter.update_column(:cat_count, counter.cat_count-1)
        end

        # находим или создаём новую запись счётчика
        counter = @hotel.town.category_counters.where(cat_type: 'hotels', cat_id: params[:hotel][:hotel_category_id].to_i).first
        if counter
          counter.update_column(:cat_count, counter.cat_count+1)
        else
          counter = @hotel.town.category_counters.build(cat_type: 'hotels', cat_id: @hotel.hotel_category.id, cat_name: @hotel.hotel_category.name )
          counter.save
        end

      end

      redirect_to @hotel
      flash[:info] = 'Объект успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить объект'
      render :edit
    end
  end

  def destroy
    @hotel = Hotel.find(params[:id])

    # для нахождения счётчика
    town = @hotel.town
    cat_id = @hotel.hotel_category.id

    @hotel.destroy

    # находим и уменьшаем или удаляем счётчик
    counter = town.category_counters.where(cat_type: 'hotels', cat_id: cat_id).first
    if counter.cat_count == 1
      counter.destroy
    else
      counter.update_column(:cat_count, counter.cat_count-1)
    end

    flash[:info] = 'Объект удалён'
    redirect_to @hotel.user
  end

  # Изменяет статус активации
  #TODO: или реализовать или удалить активацию
  def change_activated    
    hotel = Hotel.find(params[:id])
    hotel.toggle!(:activated)
    #UserMailer.change_activated(hotel).deliver_now if hotel.activated?
    redirect_back(fallback_location: hotels_path)
  end

  # Изменяет аватар объекта
  def change_avatar
    @hotel = Hotel.find(params[:id])
    @hotel.avatar = params[:avatar]
    flash[:warning] = "Неудачная загрузка. Проверьте тип и размер файла" unless @hotel.save
    redirect_back(fallback_location: root_path)    
  end  
  
private

  def correct_user
    @hotel = Hotel.find(params[:id])
    redirect_to root_url unless current_user && (current_user?(@hotel.user) || current_user.admin?)
  end
  
  def admin_for_change
    redirect_to root_url unless (current_user && current_user.admin?) 
  end  

  def hotel_params
    params.require(:hotel).permit(:name, :price_from, :address, :distance_to_sea, :latitude, :longitude,
                                  :hotel_category_id, :town_id, :site, :description, :all_year,
                                  :email, :avatar, { images: [], comfort_ids: [] })
  end
  
end