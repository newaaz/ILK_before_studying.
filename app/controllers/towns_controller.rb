class TownsController < ApplicationController

  before_action :user_admin, except: [:show, :hotels]

  def index
    @towns = Town.all    
  end
  
  def show
    @town = Town.find(params[:id])
    @hotels = @town.hotels
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

  # Метод выводит всё жильё принадлежащее городу
  def hotels
    @town = Town.find(params[:id])
    @hotel_categories = HotelCategory.all
    if params[:cat].blank?
      @hotels = @town.hotels
    else
      @hotels = @town.hotels.where(hotel_category: params[:cat].to_i)
      @hotel_cat = HotelCategory.find(params[:cat].to_i).name
    end

    # определяем массив запомненных ID отелей
    @array_resources_ids = []
    @cart.line_items.each do |line_item|
      @array_resources_ids << line_item.resource_id
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
