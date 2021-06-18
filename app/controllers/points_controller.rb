class PointsController<ApplicationController

  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    redirect_to root_url unless current_user && current_user.admin
    @points = Point.all.order(created_at: :desc)
  end

  def show
    @point = Point.find(params[:id])
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
    #debugger
    @point = current_user.points.build(point_params)
    @point.desc_json = JSON.parse(params[:desc_json])
    # set Desc_json: town_name & cat_name -> in Model (after_save)
    if @point.save
      flash[:success] = "Объект добавлен и ожидает проверки модератором. 
                        При успешной проверке Вам на почту придёт письмо, и страница 
                        будет доступна для просмотра всем посетителям сайта"
      redirect_to @point
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
    if @point.update(point_params)
      redirect_to point_path
      flash[:info] = 'Объект успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить объект'
      render :edit
    end  
  end

  def destroy
    @point = Point.find(params[:id])
    @point.destroy
    flash[:info] = 'Объект удалён'
    redirect_to root_url
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