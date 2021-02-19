class TownsController < ApplicationController

  before_action :user_admin, except: :show

  def index
    @towns = Town.all    
  end
  
  def show
    @town = Town.find(params[:id])
    
  end
  
  def new
    @town = Town.new
  end

  def create
    @town = Town.new(town_params)
    if @town.save
      flash[:success] = "Город успешно создан"
      redirect_to @town
    else
      render 'new'
    end
  end

  def edit
    @town = Town.find(params[:id])
  end

  def update
    @town = Town.find(params[:id])
    if @town.update(town_params)
      redirect_to town_path
      flash[:info] = 'Город успешно изменён'
    else
      flash.now[:warning] = 'Не получилось изменить город'
      render :edit
    end
  end

  def destroy
    @town = Town.find(params[:id])
    @town.destroy
    flash[:info] = 'Город удалён'
    redirect_to towns_path
  end

  # Метод выводит все кафе принадлежащие городу
  def cafe
    @town = Town.find(params[:id])    
    @tagcafebars = Tagcafebar.all  
    if params[:tag].blank?
      @cafebars = @town.cafebars.enabled
    else
      @tag = Tagcafebar.find(params[:tag].to_i)
      @cafebars = @tag.cafebars.enabled.where(town_id: @town.id)
    end    
  end

  # Метод выводит всё жильё принадлежащее городу
  def hotels
    @town = Town.find(params[:id])
    @hotel_categories = HotelCategory.all
    if params[:cat].blank?
      @hotels = @town.hotels.enabled
    else
      @hotels = @town.hotels.enabled.where(hotel_category: params[:cat].to_i)
      @hotel_cat = HotelCategory.find(params[:cat].to_i).name
    end
  end

  private

  def town_params
    params.require(:town).permit(:name, :parent_name, :number, :avatar)
  end

  def user_admin
    redirect_to root_path unless current_user && current_user.admin?
  end
  
  
end
