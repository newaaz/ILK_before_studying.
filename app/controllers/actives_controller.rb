class ActivesController<ApplicationController

  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    #TODO: реализовать общую проверку адимновских методов
    redirect_to root_url unless current_user && current_user.admin
    @actives = Active.all.order(created_at: :desc)
  end

  def show
    @active = Active.find(params[:id])

    # проверяем активацию ресурса
    unless @active.activated?
      unless current_user && (current_user?(@active.user) || current_user.admin?)
        flash[:info] = 'Объект ждёт проверки модератором и активации'
        redirect_back(fallback_location: root_url)
      end
    end

    # @service_categories = ServiceCategory.select(:id, :name).all
    # определение города к которому относится сервис
    #FIXME: сейчас город определяется если заходить со страницы города, проработать другие варианты определения города - например с помощью определения местоположения
    if params[:town_id].blank?
      #FIXME: реализовать оптимальное определение города
      @town = @active.towns.first
    else
      @town = Town.find(params[:town_id].to_i)
    end
    
    # определяем - является ли этот сервис запомненным    
    current_item = @cart.line_items.find_by(resource_id: params[:id], resource_name: 'Active') if @cart
    @current_item = true if current_item 
  end

  def new
    @active = Active.new
  end

  def create
    @active = current_user.actives.build(active_params)
    @active.desc_json = JSON.parse(params[:desc_json])
    # set Desc_json: cat_name -> in Model (after_save)  
    if @active.save
      flash[:success] = "#{@active.name} - Активный отдых добавлен и ожидает проверки модератором. 
                        При успешной проверке Вам на почту придёт письмо, о том что страница активирована и доступна для всех посетителей сайта"
      # Отправляем админу письмо о создании ресурса
      #TODO: Включить отправку письма при создании ресурса
      # UserMailer.resource_create(@active).deliver_now
      redirect_to @active
    else
      render 'new'
    end
  end

  def edit
    @active = Active.find(params[:id])
  end

  def update
    @active = Active.find(params[:id])
    @active.desc_json = JSON.parse(params[:desc_json])
    # set Desc_json: cat_name -> in Model (after_save)
    
    # Запоминаем категорию ресурса и список его городов
    old_cat = @active.active_category.id
    old_towns = @active.town_ids

    if @active.update(active_params)

      # сравниваем старые и новые значение. Если есть изменения - 
      # запускаем циклы для старых и новых городов
      if old_cat != @active.active_category.id || old_towns != @active.town_ids
      
        # В старых городах уменьшаем или удаляем позиции
        towns = Town.find(old_towns)
        towns.each do |town|
          counter = town.category_counters.where(cat_type: 'actives', cat_id: old_cat).first
          if counter.cat_count == 1
            counter.destroy
          else
            counter.update_column(:cat_count, counter.cat_count-1)
          end
        end

        # В новых городах добавляем или создаем позиции
        @active.towns.each do |town|
          counter = town.category_counters.where(cat_type: 'actives', cat_id: @active.active_category.id).first
          if counter
            counter.update_column(:cat_count, counter.cat_count+1)
          else
            counter = town.category_counters.build(cat_type: 'actives', cat_id: @active.active_category.id, cat_name: @active.active_category.name )
            counter.save
          end
        end
      
      end

      flash[:info] = 'Активный отдых успешно изменён'
      redirect_to active_path      
    else
      flash.now[:warning] = 'Не получилось изменить'
      render :edit
    end  
  end

  def destroy
    @active = Active.find(params[:id])

    # Для определения счётчика    
    cat_id = @active.active_category.id
    town_ids = @active.town_ids

    @active.destroy

    # находим и уменьшаем или удаляем счётчик В КАЖДОМ ГОРОДЕ
    towns = Town.find(town_ids)
    towns.each do |town|
      counter = town.category_counters.where(cat_type: 'actives', cat_id: cat_id).first
      if counter.cat_count == 1
        counter.destroy
      else
        counter.update_column(:cat_count, counter.cat_count-1)
      end
    end
    
    flash[:info] = 'Активный отдых удалён'
    redirect_to @active.user
  end 

  # Изменяет параметр продвижения (реклама, промо)
  def change_promo
    #TODO: реализовать общую проверку адимновских методов
    redirect_to root_url unless current_user.admin
   
    active = Active.find(params[:id])
    active.update_column(:promouted, params[:promouted].to_i)
    redirect_back(fallback_location: actives_path)
  end

private

  def correct_user
    @active = Active.find(params[:id])
    redirect_back(fallback_location: root_url) unless current_user?(@active.user) || current_user.admin?
  end

  # Разрешённые параметры
  def active_params
    params.require(:active).permit(:name, :avatar, :active_category_id, :description,
                                    :price, :latitude, :longitude, { images: [], town_ids: [] })
  end



end