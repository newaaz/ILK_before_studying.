class LineItemsController < ApplicationController

  before_action :set_cart, only: :create

  def create  
    current_item = @cart.line_items.find_by(resource_name: params[:resource_name],
                                            resource_id: params[:resource_id])
    if current_item           # если такой ресурс уже добавлен в избранное - удаляем
      current_item.destroy
      respond_to do |format|        
        format.js
      end      
    else                      # если не добавлен - добавляем
      @line_item = @cart.line_items.build(resource_id: params[:resource_id], resource_name: params[:resource_name])
      respond_to do |format|
        if @line_item.save          
          format.js { @new = true }    
        else
          format.html { redirect_back(fallback_location: root_url) }
          flash[:success] = "Не удалось добавить в избранное"
        end
      end
    end
    
  end


end

