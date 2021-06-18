class ServiceCategoriesController<ApplicationController

  before_action :user_admin

  def index
    @service_categories = ServiceCategory.all
  end

  def new
    @service_category = ServiceCategory.new    
  end

  def create
    @service_category = ServiceCategory.new(category_params)
    if @service_category.save
      flash[:success] = "Категория успешно создана"
      redirect_to service_categories_path
    else
      flash[:info] = "Категория не создана"
      render :new
    end
  end

  def edit
    @service_category = ServiceCategory.find(params[:id])    
  end

  def update
    @service_category = ServiceCategory.find(params[:id])
    if @service_category.update(category_params)
      redirect_to service_categories_path
      flash.now[:info] = 'Категория успешно обновлена'
    else
      flash.now[:info] = 'Категория не обновлена'
      render :edit
    end
  end

  def destroy
    @service_category = ServiceCategory.find(params[:id])
    @service_category.destroy
    flash[:info] = 'Категория удалена'
    redirect_to service_categories_path
  end

private

  # Разрешённые параметры
  def category_params
    params.require(:service_category).permit(:name, :number, :avatar)
  end

  def user_admin
    redirect_to root_path unless current_user && current_user.admin?
  end
end