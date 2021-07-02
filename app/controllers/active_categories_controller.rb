class ActiveCategoriesController<ApplicationController

  before_action :user_admin

  def index
    @active_categories = ActiveCategory.all
  end

  def new
    @active_category = ActiveCategory.new    
  end

  def create
    @active_category = ActiveCategory.new(category_params)
    if @active_category.save
      flash[:success] = "Категория успешно создана"
      redirect_to active_categories_path
    else
      flash[:info] = "Категория не создана"
      render :new
    end
  end

  def edit
    @active_category = ActiveCategory.find(params[:id])    
  end

  def update
    @active_category = ActiveCategory.find(params[:id])
    if @active_category.update(category_params)
      redirect_to active_categories_path
      flash.now[:info] = 'Категория успешно обновлена'
    else
      flash.now[:info] = 'Категория не обновлена'
      render :edit
    end
  end

  def destroy
    @active_category = ActiveCategory.find(params[:id])
    @active_category.destroy      
    flash[:info] = "Категория удалена"
    redirect_to active_categories_path
  end

private

  # Разрешённые параметры
  def category_params
    params.require(:active_category).permit(:name, :number, :avatar)
  end

  def user_admin
    redirect_to root_path unless current_user && current_user.admin?
  end
end