class TagcafebarsController<ApplicationController

  before_action :user_admin

  def index
    @tagcafebars = Tagcafebar.all
  end  

  def new
    @tagcafebar = Tagcafebar.new    
  end

  def create
    @tagcafebar = Tagcafebar.new(tagcafebar_params)
    if @tagcafebar.save
      flash[:success] = "Тег для кафе создан"
      redirect_to tagcafebars_path
    else
      flash[:info] = "Тег для кафе не создан"
      render :new
    end
  end

  def edit
    @tagcafebar = Tagcafebar.find(params[:id])    
  end

  def update
    @tagcafebar = Tagcafebar.find(params[:id])
    if @tagcafebar.update(tagcafebar_params)
      redirect_to tagcafebars_path
      flash.now[:info] = 'Тег для кафе обновлен'
    else
      flash.now[:info] = 'Тег для кафе не обновлен'
      render :edit
    end
  end

  def destroy
    @tagcafebar = Tagcafebar.find(params[:id])
    @tagcafebar.destroy
    flash[:info] = 'Тег для кафе удален'
    redirect_to tagcafebars_path
  end

private

  # Разрешённые параметры
  def tagcafebar_params
    params.require(:tagcafebar).permit(:name, :icon)
  end

  def user_admin
    redirect_to root_path unless current_user && current_user.admin?
  end
end