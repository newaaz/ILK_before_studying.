class CafebarsController<ApplicationController

  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    redirect_to root_url unless current_user && current_user.admin
    @cafebars = Cafebar.all.order(created_at: :desc)
  end

  def show
    @cafebar = Cafebar.find(params[:id])
    @town = @cafebar.town
    # определяем - является ли этот отель запомненным    
    current_item = @cart.line_items.find_by(resource_id: params[:id], resource_name: 'Cafebar') if @cart
    @current_item = true if current_item
  end

  def new
    @cafebar = Cafebar.new
  end

  def create
    @cafebar = current_user.cafebars.build(cafebar_params)
    @cafebar.desc_json = JSON.parse(params[:desc_json])
    @cafebar.desc_json['town_name'] = @cafebar.town.name
    if @cafebar.save
      flash[:success] = "Объект добавлен и ожидает проверки модератором. 
                        При успешной проверке Вам на почту придёт письмо, и страница 
                        будет доступна для просмотра всем посетителям сайта"
      redirect_to @cafebar
    else
      render 'new'
    end
  end

  def edit
    @cafebar = Cafebar.find(params[:id])
  end

  def update
    @cafebar = Cafebar.find(params[:id])
    @cafebar.desc_json = JSON.parse(params[:desc_json])
    @cafebar.desc_json['town_name'] = @cafebar.town.name
    if @cafebar.update(cafebar_params)
      redirect_to cafebar_path
      flash[:info] = 'Объект успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить объект'
      render :edit
    end  
  end

  def destroy
    @cafebar = Cafebar.find(params[:id])
    @cafebar.destroy
    flash[:info] = 'Объект удалён'
    redirect_to root_url
  end

private

  def correct_user
    @cafebar = Cafebar.find(params[:id])
    redirect_back(fallback_location: root_url) unless current_user?(@cafebar.user) || current_user.admin?
  end

  # Разрешённые параметры
  def cafebar_params
    params.require(:cafebar).permit(:name, :avatar, :address, :phone, :site, :email, :instagram, :town_id, :menu,
                                    :vk, :latitude, :longitude, :description, { images: [], tagcafebar_ids: [] })
  end

end