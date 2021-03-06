class LineItemsController < ApplicationController

  def create
    #debugger
    current_item = @cart.line_items.find_by(resource_id: params[:resource_id])

    if current_item           # если такая позиция уже есть
      current_item.destroy
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_url) }
        format.js   
      end      
    else                      # если такой позиции ещё нет
      @line_item = @cart.line_items.build(resource_id: params[:resource_id])
      respond_to do |format|
        if @line_item.save
          format.html { redirect_back(fallback_location: root_url) }
          format.js        
        else
          format.html { redirect_back(fallback_location: root_url) }
          flash[:success] = "Не удалось добавить в избранное"
        end
      end
    end


    
  end

end

