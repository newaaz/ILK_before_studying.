class UsersController < ApplicationController

  layout 'clean', only: :new

  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:show, :edit, :update, :destroy]
  
  def index
    redirect_to root_url unless current_user.admin?
    @pagy, @users = pagy(User.all, items: 3)
  end

  def show
    # @user определяется в методе :correct_user
    # @user = User.find(params[:id])

    @hotels = @user.hotels.includes(:rooms).references(:rooms).order(:number)
    @actives = @user.actives
    @cafebars = @user.cafebars
    @points = @user.points
    @services = @user.services  
    
    # определяем заявки которые принял User в качестве владельца жилья
    @hotel_orders = current_user.owner_orders unless current_user.owner_orders.nil?
    # определяем заявки которые отправлял User в качестве гостя
    @hotel_out_orders = Order.where('user_id = ?', current_user.id)

    # заявки на активный отдых которые принял User в качестве владельца
    @active_orders = current_user.owner_active_orders unless current_user.owner_active_orders.nil?
    # заявки которые отправил User в качестве заказчика
    @active_out_orders = OrderActive.where('user_id = ?', current_user.id)

  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # отправка письма с токеном активации
      UserMailer.account_activation(@user).deliver_now    
      flash[:info] = "Проверьте свою почту для активации учётной записи"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    # @user определяется в методе :correct_user
    # @user = User.find(params[:id])    
  end

  def update
    # @user определяется в методе :correct_user
    # @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:info] = "Ваши данные успешно изменены"
      redirect_to @user
    else
      #render 'show'
      flash[:danger] = "Изменения не сохранились"
      redirect_to @user
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь удалён"
    redirect_back(fallback_location: root_url)
  end

private

  # Метод logged_in_user находится в Application_controller

  def user_params
    params.require(:user).permit(:name, :email, :phone, :avatar, :password, :password_confirmation)
  end

  def correct_user
    # если работает проверка в методе current_user? на наличие user
    # проверка работает, значит здесь проверка на наличие текущего
    # пользователя не нужна. Но на всякий случай оставлю её здесь
    #redirect_to(root_url) if current_user.nil

    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) || current_user.admin?
  end

end
