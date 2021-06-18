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
    if @service.update(service_params)
      redirect_to service_path
      flash[:info] = 'Сервис успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить Сервис'
      render :edit
    end  
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy
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