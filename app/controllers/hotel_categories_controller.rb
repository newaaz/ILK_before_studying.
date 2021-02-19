class HotelCategoriesController<ApplicationController

  before_action :user_admin

  def index
    @hotel_categories = HotelCategory.all
  end

  def new
    @hotel_category = HotelCategory.new    
  end

  def create
    @hotel_category = HotelCategory.new(category_params)
    if @hotel_category.save
      flash[:success] = "Категория успешно создана"
      redirect_to hotel_categories_path
    else
      flash[:info] = "Категория не создана"
      render :new
    end
  end

  def edit
    @hotel_category = HotelCategory.find(params[:id])    
  end

  def update
    @hotel_category = HotelCategory.find(params[:id])
    if @hotel_category.update(category_params)
      redirect_to hotel_categories_path
      flash.now[:info] = 'Категория успешно обновлена'
    else
      flash.now[:info] = 'Категория не обновлена'
      render :edit
    end
  end

  def destroy
    @hotel_category = HotelCategory.find(params[:id])
    @hotel_category.destroy
    flash[:info] = 'Категория удалена'
    redirect_to hotel_categories_path
  end

private

  # Разрешённые параметры
  def category_params
    params.require(:hotel_category).permit(:name, :number)
  end

  def user_admin
    redirect_to root_path unless current_user && current_user.admin?
  end
end