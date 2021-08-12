class OrdersController<ApplicationController
  
  before_action :correct_user, only: :show
  before_action :correct_room_new, only: :new
  before_action :correct_room_create, only: :create
  
  def index
    redirect_back(fallback_location: root_url)
    #redirect_to root_url unless (current_user && current_user.admin?)
    flash[:info] = "Попробуйте ещё раз заполнив правильно"
  end
  
  def show
    @order = Order.find(params[:id])       
  end  

  def new
    @hotel = Hotel.find(params[:hotel_id].to_i)    
    # Для заявки поступающей с определённого типа номера
    @room = Room.find(params[:room_id].to_i) if params[:room_id]
    @order = Order.new    
  end

  def create
    @hotel = Hotel.find(params[:hotel_id].to_i)
    @order = @hotel.orders.build(order_params)

    #TODO: что-то придумать когда заявку делает незарегистрированный пользователь
    if current_user
      @order[:user_id] = current_user[:id]
    else
      # владельцем исходящих заявок от незарегистрированных пользователей становится админ
      @order[:user_id] = User.find_by('email = ?', 'newaz@mail.ru').id
    end

    if @order.save
      #FIXME: Отправка писем владельцу жилья и гостю
      #UserMailer.owner_user_reservation(@order).deliver_now
      #UserMailer.guest_reservation(@order).deliver_now
      flash[:success] = "Ваша заявка отправлена, в ближайшее время с Вами должны связаться по указанным контактам"      
      redirect_to @hotel
      #redirect_back(fallback_location: root_path)
    else
      flash[:info] = "Не получилось отправить заявку"
      #redirect_back(fallback_location: root_path)      
      render "new"
    end
  end  

private

  # Разрешённые параметры
  def order_params
    params.require(:order).permit(:guest_name, :guest_email, :guest_phone, :check_in, :check_out,
                                  :adults, :kids, :room_id, :wishes, :owner_comment, :total_amount)
  end

  # Корректный пользователь - владелец отеля заявки, или админ
  def correct_user
    order = Order.find(params[:id])
    redirect_to root_url unless current_user && (current_user?(order.owner_user) || current_user.admin?)
  end

  # Проверям принадлежит ли выбранный номер отелю (при создании заявки)
  def correct_room_new
    if params[:hotel_id] && params[:room_id]
      redirect_to root_url unless Hotel.find(params[:hotel_id].to_i).room_ids.include?(params[:room_id].to_i)
    end
  end

  def correct_room_create
    if room_hotel_id = params[:order][:room_id]
      #redirect_to root_url unless Hotel.find(params[:hotel_id].to_i).room_ids.include?(room_hotel_id.to_i)
      redirect_to root_url unless Hotel.find(params[:hotel_id].to_i).rooms.exists?(room_hotel_id.to_i)
    end
  end

end