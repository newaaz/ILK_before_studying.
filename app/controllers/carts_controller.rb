class CartsController < ApplicationController

  def show
    # отправляем на show если Cart не существует
    if params[:id] == 'blank'
      render 'show'
    else
      @cart = Cart.find(params[:id])
      array_resources_ids = []
      @cart.line_items.each do |line_item|
        array_resources_ids << line_item.resource_id
      end
      @hotels = Hotel.find(array_resources_ids)
      @referer_page = request.referer
    end
    
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
      @cart.destroy if @cart.id == session[:cart_id]
      session[:cart_id] = nil    
      #redirect_to root_url, notice: "Корзина очищена"
      flash[:info] = "Список избранного пуст"
      redirect_to params[:referer_page] || root_url      
    end    
  
  end

end