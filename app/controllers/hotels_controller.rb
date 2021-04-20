class HotelsController < ApplicationController  
  
  before_action :logged_in_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index    
    redirect_back(fallback_location: root_url) unless current_user && current_user.admin?  
    @hotels = Hotel.all.order(created_at: :desc)    
  end
  
  def show
    @hotel = Hotel.includes(:rooms).references(:rooms).order(:number).find(params[:id])
    # определяем - является ли этот отель запомненным    
    current_item = @cart.line_items.find_by(resource_id: params[:id], resource_name: 'Hotel') if @cart
    @current_item = true if current_item
  end
  
  def new
    @hotel = Hotel.new    
  end

  def create
    # debugger
    @hotel = current_user.hotels.build(hotel_params)
    @hotel.desc_json = params[:desc_json]
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
    if @hotel.update(hotel_params)
      redirect_to @hotel
      flash[:info] = 'Объект успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить объект'
      render :edit
    end
  end

  def destroy
    @hotel = Hotel.find(params[:id])
    @hotel.destroy
    redirect_to @hotel.user
  end

  # Изменяет статус активации
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
    params.require(:hotel).permit(:name, :price_from, :address, :distance_to_sea, :latitude, :longitude, :vk,
                                  :hotel_category_id, :town_id, :site, :description, :food, :parking, :territory,
                                  :transfer, :service, :addition, :instagram, :all_year, :floors,
                                  :email, :avatar, { images: [], comfort_ids: [] })
  end
  
end