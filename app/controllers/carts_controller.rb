class CartsController < ApplicationController

  def show
    @cart = Cart.find(params[:id])
    array_resorces_ids = []
    @cart.line_items.each do |line_item|
      array_resorces_ids << line_item.resource_id
    end
   @hotels = Hotel.find(array_resorces_ids)  
  end
  
  def destroy
    # destroy с удалением корзины
    # @cart.destroy if @cart.id == session[:cart_id]
    # session[:cart_id] = nil    
    # redirect_to root_url, notice: "Корзина очищена"
    
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