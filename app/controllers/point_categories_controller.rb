class PointCategoriesController<ApplicationController

  before_action :user_admin

  def index
    @point_categories = PointCategory.all
  end

  def new
    @point_category = PointCategory.new    
  end

  def create
    @point_category = PointCategory.new(category_params)
    if @point_category.save
      flash[:success] = "Категория успешно создана"
      redirect_to point_categories_path
    else
      flash[:info] = "Категория не создана"
      render :new
    end
  end

  def edit
    @point_category = PointCategory.find(params[:id])    
  end

  def update
    @point_category = PointCategory.find(params[:id])
    if @point_category.update(category_params)
      redirect_to point_categories_path
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
    params.require(:point_category).permit(:name, :number, :avatar)
  end

  def user_admin
    redirect_to root_path unless current_user && current_user.admin?
  end
end