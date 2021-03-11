class RoomsController<ApplicationController

  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user, except: [:new, :create, :show, :index]
  before_action :correct_user_rooms_for_create, only: [:new, :create]

  def index
    redirect_back(fallback_location: root_url)
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    if params[:hotel_id].to_i == 0
      redirect_to root_url
    else
      @hotel = Hotel.find(params[:hotel_id].to_i)
      @room = Room.new 
      @room.prices.build
    end
  end

  def create
    @hotel = Hotel.find(params[:hotel_id].to_i)
    @room = @hotel.rooms.build(room_params)    
    if @room.save
      flash[:success] = "Номер добавлен"
      redirect_to @hotel
    else
      # убираем, потому что кроме этого отображаются ошибки валидации
      #flash[:info] = "Не получилось добавить номер"
      render :new
    end
  end

  def edit
    if params[:hotel_id].to_i == 0
      redirect_to root_url
    else
      @hotel = Hotel.find(params[:hotel_id].to_i)
      @room = Room.find(params[:id]) 
    end      
  end

  def update    
    @room = Room.find(params[:id])
    @hotel = @room.hotel
    if @room.update(room_params)
      redirect_to @hotel
      flash.now[:info] = 'Номер успешно обновлен'
    else  
      # убираем, потому что кроме этого отображаются ошибки валидации    
      # flash.now[:info] = 'Номер не обновлен'
      render :edit
    end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    flash[:info] = 'Номер удален'
    redirect_back(fallback_location: root_path)
  end

private

  # Разрешённые параметры
  def room_params
    params.require(:room).permit(:name, :number, :description, :size, { images: [] },
      prices_attributes: [:id, :start_date, :end_date, :day_cost, :_destroy])
  end

  # проверяем пользователя являетля ли он владельцем отеля для которого создаётся номер
  def correct_user_rooms_for_create
    #debugger
    hotel = Hotel.find(params[:hotel_id].to_i)
    redirect_to root_path unless current_user?(hotel.user) || current_user.admin?
  end

  # проверяем является ли текущий пользователь владельцем отеля
  def correct_user
    hotel = Room.find(params[:id].to_i).hotel
    redirect_to root_path unless current_user?(hotel.user) || current_user.admin?
  end

end