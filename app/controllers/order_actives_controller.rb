class OrderActivesController<ApplicationController


  before_action :correct_user, only: :show

  before_action :logged_in_user, only: [:show]

  def index
  end

  def show
    order = OrderActive.find(params[:id])
    order_client = User.find(order.user_id)

    if order.owner_user == order_client
      @order = OrderActive.find(params[:id])
      render 'show'
    elsif order_client == current_user
      @order = OrderActive.find(params[:id])
      render 'show_client'
    elsif current_user?(order.owner_user)
      @order = OrderActive.find(params[:id])
      render 'show_owner' 
    end

  end

  def new
    @active = Active.find(params[:active_id].to_i)
    #TODO: в заявке определять город с которого пришли из Active
    @order_active = OrderActive.new  
  end

  def create
    @active = Active.find(params[:active_id].to_i) 
    @order_active = @active.order_actives.build(order_active_params)

    #TODO: что-то придумать когда заявку делает незарегистрированный пользователь
    if current_user
      @order_active[:user_id] = current_user[:id]
    else
      # владельцем исходящих заявок от незарегистрированных пользователей становится админ
      @order_active[:user_id] = User.find_by('email = ?', 'newaz@mail.ru').id
    end

    if @order_active.save
      #FIXME: Отправка писем владельцу Активности и клиенту
      #UserMailer.active_reservation_owner(@order_active).deliver_now
      #UserMailer.active_reservation_guest(@order_active).deliver_now
      flash[:success] = "Ваша заявка отправлена, в ближайшее время с Вами должны связаться по указанным контактам"      
      redirect_to @active
      #redirect_back(fallback_location: root_path)
    else
      flash[:info] = "Не получилось отправить заявку"
      #redirect_back(fallback_location: root_path)      
      render "new"
    end
  end

private

  # Разрешённые параметры
  def order_active_params
    params.require(:order_active).permit(:guest_name, :guest_email, :guest_phone, :wish_date,
                                  :adults, :wishes)
  end

  # Корректный пользователь - владелец Активности заявки или её заказчик, или админ
  def correct_user
    order = OrderActive.find(params[:id])
    order_client = User.find(order.user_id)
    redirect_to root_url unless current_user && (current_user?(order.owner_user) || order_client == current_user || current_user.admin?)
  end


end