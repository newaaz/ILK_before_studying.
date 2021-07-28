class PointsController<ApplicationController

  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    redirect_to root_url unless current_user && current_user.admin
    @points = Point.all.order(created_at: :desc)
  end

  def show
    @point = Point.find(params[:id])

    # проверяем активацию ресурса
    unless @point.activated?
      unless current_user && (current_user?(@point.user) || current_user.admin?)
      flash[:info] = 'Объект ждёт проверки модератором и активации'
      redirect_back(fallback_location: root_url)
      end
    end

    @point_categories = PointCategory.all
    @town = @point.town
    # определяем - является ли этот Поинт запомненным    
    current_item = @cart.line_items.find_by(resource_id: params[:id], resource_name: 'Point') if @cart
    @current_item = true if current_item 
  end

  def new
    @point = Point.new
  end

  def create    
    @point = current_user.points.build(point_params)
    @point.desc_json = JSON.parse(params[:desc_json])
    # set Desc_json: town_name & cat_name -> in Model (after_save)
    if @point.save
      flash[:success] = "Объект добавлен и ожидает проверки модератором.
                        При успешной проверке Вам на почту придёт письмо, сообщающее
                         об активации страницы и доступности к просмотру всем посетителям сайта"      
      redirect_to @point
      # Отправляем админу письмо о создании ресурса
      #TODO: Включить отправку письма при создании ресурса
      # UserMailer.resource_create(@point).deliver_now
    else
      render 'new'
    end
  end

  def edit
    @point = Point.find(params[:id])
  end

  def update
    @point = Point.find(params[:id])
    @point.desc_json = JSON.parse(params[:desc_json])
    # set Desc_json: town_name & cat_name -> in Model (after_save) 
    
    # запоминаем старое значение категории и города
    old_cat = @point.point_category.id
    old_town = @point.town.id
    
    if @point.update(point_params)

      # сравниваем старые и новые значения после обновления
      if old_cat != @point.point_category.id || old_town != @point.town.id  # или params[:town_id] - так запроса к БД не будет
    
        # находим старую запись счётчика и меняем её (или вообще удаляем)
        counter = Town.find(old_town).category_counters.where(cat_type: 'points', cat_id: old_cat).first
        if counter.cat_count == 1
          counter.destroy
        else
          counter.update_column(:cat_count, counter.cat_count-1)
        end

        # находим или создаём новую запись счётчика
        counter = @point.town.category_counters.where(cat_type: 'points', cat_id: params[:point][:point_category_id].to_i).first
        if counter
          counter.update_column(:cat_count, counter.cat_count+1)
        else
          counter = @point.town.category_counters.build(cat_type: 'points', cat_id: @point.point_category.id, cat_name: @point.point_category.name )
          counter.save
        end

      end

      redirect_to point_path
      flash[:info] = 'Объект успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить объект'
      render :edit
    end  
  end

  def destroy
    @point = Point.find(params[:id])

    # для нахождения счётчика
    town = @point.town
    cat_id = @point.point_category.id

    @point.destroy

    # находим и уменьшаем или удаляем счётчик
    counter = town.category_counters.where(cat_type: 'points', cat_id: cat_id).first
    if counter.cat_count == 1
      counter.destroy
    else
      counter.update_column(:cat_count, counter.cat_count-1)
    end

    flash[:info] = 'Объект удалён'
    redirect_to @point.user
  end

private

  def correct_user
    @point = Point.find(params[:id])
    redirect_back(fallback_location: root_url) unless current_user?(@point.user) || current_user.admin?
  end

  # Разрешённые параметры
  def point_params
    params.require(:point).permit(:name, :avatar, :address, :town_id, :point_category_id, :how_to_get,
                                  :latitude, :longitude, :description, { images: [] })
  end

end