class ActivesController<ApplicationController

  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    redirect_to root_url unless current_user && current_user.admin
    @actives = Active.all.order(created_at: :desc)
  end

  def show
    @active = Active.find(params[:id])
    @service_categories = ServiceCategory.select(:id, :name).all
    # определение города к которому относится сервис
    #FIXME: сейчас город определяется если заходить со страницы города, проработать другие варианты определения города - например с помощью определения местоположения
    if params[:town_id].blank?
      @town = Town.first
    else
      @town = Town.find(params[:town_id].to_i)
    end
    
    # определяем - является ли этот сервис запомненным    
    current_item = @cart.line_items.find_by(resource_id: params[:id], resource_name: 'Service') if @cart
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
      flash[:success] = "#{@active.name} - добавлен и ожидает проверки модератором. 
                        При успешной проверке Вам на почту придёт письмо, и страница 
                        будет доступна для просмотра всем посетителям сайта"
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
    if @active.update(active_params)
      redirect_to active_path
      flash[:info] = 'Активный отдых успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить'
      render :edit
    end  
  end

  def destroy
    @active = Active.find(params[:id])
    @active.destroy
    flash[:info] = 'Активный отдых удалён'
    redirect_to root_url
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