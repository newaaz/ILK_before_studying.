class ServicesController<ApplicationController

  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    redirect_to root_url unless current_user && current_user.admin
    @services = Service.all.order(created_at: :desc)
  end

  def show
    @service = Service.find(params[:id])
    @service_categories = ServiceCategory.select(:id, :name).all
    # определение города к которому относится сервис
    #FIXME: сейчас город определяется если заходить со страницы города, проработать другие варианты определения города - например с помощью определения местоположения
    if params[:town_id].blank?
      @town = @service.towns.first
      #FIXME: реализовать оптимальное определение города
      
    else
      @town = Town.find(params[:town_id].to_i)
    end
    
    # определяем - является ли этот сервис запомненным    
    current_item = @cart.line_items.find_by(resource_id: params[:id], resource_name: 'Service') if @cart
    @current_item = true if current_item 
  end

  def new
    @service = Service.new
  end

  def create
    @service = current_user.services.build(service_params)
    @service.desc_json = JSON.parse(params[:desc_json])
    # set Desc_json: cat_name -> in Model (after_save)  
    if @service.save
      flash[:success] = "Услуга/Сервис добавлен и ожидает проверки модератором. 
                        При успешной проверке Вам на почту придёт письмо, и страница 
                        будет доступна для просмотра всем посетителям сайта"
      redirect_to @service
    else
      render 'new'
    end
  end

  def edit
    @service = Service.find(params[:id])
  end

  def update
    @service = Service.find(params[:id])
    @service.desc_json = JSON.parse(params[:desc_json])
    # set Desc_json: cat_name -> in Model (after_save)

    # Запоминаем категорию ресурса и список его городов
    old_cat = @service.service_category.id
    old_towns = @service.town_ids

    if @service.update(service_params)

      # сравниваем старые и новые значение. Если есть изменения - 
      # запускаем циклы для старых и новых городов
      if old_cat != @service.service_category.id || old_towns != @service.town_ids
      
        # В старых городах уменьшаем или удаляем позиции
        towns = Town.find(old_towns)
        towns.each do |town|
          counter = town.category_counters.where(cat_type: 'services', cat_id: old_cat).first
          if counter.cat_count == 1
            counter.destroy
          else
            counter.update_column(:cat_count, counter.cat_count-1)
          end
        end

        # В новых городах добавляем или создаем позиции
        @service.towns.each do |town|
          counter = town.category_counters.where(cat_type: 'services', cat_id: @service.service_category.id).first
          if counter
            counter.update_column(:cat_count, counter.cat_count+1)
          else
            counter = town.category_counters.build(cat_type: 'services', cat_id: @service.service_category.id, cat_name: @service.service_category.name )
            counter.save
          end
        end
      
      end


      redirect_to service_path
      flash[:info] = 'Сервис успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить Сервис'
      render :edit
    end  
  end

  def destroy
    @service = Service.find(params[:id])

    # Для определения счётчика    
    cat_id = @service.service_category.id
    town_ids = @service.town_ids

    @service.destroy

    # находим и уменьшаем или удаляем счётчик В КАЖДОМ ГОРОДЕ
    towns = Town.find(town_ids)
    towns.each do |town|
      counter = town.category_counters.where(cat_type: 'services', cat_id: cat_id).first
      if counter.cat_count == 1
        counter.destroy
      else
        counter.update_column(:cat_count, counter.cat_count-1)
      end
    end

    flash[:info] = 'Сервис удалён'
    redirect_to root_url
  end

private

  def correct_user
    @service = Service.find(params[:id])
    redirect_back(fallback_location: root_url) unless current_user?(@service.user) || current_user.admin?
  end

  # Разрешённые параметры
  def service_params
    params.require(:service).permit(:name, :avatar, :address, :service_category_id, :description, :addition,
                                    :price, :latitude, :longitude, { images: [], town_ids: [] })
  end



end