class CartsController < ApplicationController

  def show
    @cart = Cart.find(params[:id])
    array_resources_ids = []
    @cart.line_items.each do |line_item|
      array_resources_ids << line_item.resource_id
    end
   @hotels = Hotel.find(array_resources_ids)
  end
  
  def destroy
    # destroy с удалением корзины
    # @cart.destroy if @cart.id == session[:cart_id]
    # session[:cart_id] = nil    
    # redirect_to root_url, notice: "Корзина очищена"

    if params[:resource_id]  # Если есть ID ресурса - удаляем только позицию
      line_items = @cart.line_items
      line_items.find_by('resource_id = ?', params[:resource_id]).destroy
      redirect_to @cart
    else                     # Иначе очищаем корзину полностью
      # destroy без удаления корзины
      if @cart.line_items.any?
        @cart.line_items.each do |line_item|
          line_item.destroy
        end
          redirect_to @cart
          flash[:success] = "Список очищен"
      else
        redirect_to @cart
        flash[:success] = "Список уже пуст"
      end
    end    
  
  end

end