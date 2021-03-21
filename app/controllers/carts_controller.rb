class CartsController < ApplicationController

  before_action :correct_cart, only: :show

  def show
    # отправляем на show если Cart не существует
    if params[:id] == 'blank'
      render 'show'
    else
      @cart = Cart.find(params[:id])
      array_hotel_ids = []
      @cart.line_items.where('resource_name = ?', 'Hotel').each do |line_item|
        array_hotel_ids << line_item.resource_id
      end
      @hotels = Hotel.find(array_hotel_ids)
      @referer_page = request.referer
    end
    
  end
  
  def destroy
    if params[:resource_id] || params[:resource_name] # Если есть ресурс - удаляем только позицию
      @cart.line_items.find_by(resource_name: params[:resource_name],
                                resource_id: params[:resource_id]).destroy
      respond_to do |format|
        format.js { @resource_id_in_cart = "#{params[:resource_name]}-#{params[:resource_id]}" }
      end      
    else                     # Иначе очищаем корзину полностью
      @cart.destroy if @cart.id == session[:cart_id]
      session[:cart_id] = nil    
      flash[:info] = "Список избранного пуст"
      respond_to do |format|
        format.html { redirect_to params[:referer_page] || root_url }
      end   
    end    
  
  end

private

  def correct_cart
    redirect_to root_url unless params[:id].to_i == session[:cart_id].to_i
  end

end