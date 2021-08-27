class ImagesController < ApplicationController

  before_action :logged_in_user        # нужна для проверки существования текущего пользователя
  before_action :set_model_instance    # определяет экземпляр передаваемой модели  
  before_action :correct_user          # проверяет что пользователю принадлежат ресурсы

  def create    
    if params[:images].blank?
      flash[:info] = "Выберите изображения которые хотите добавить"
      redirect_back(fallback_location: root_path)
    else 
      # добавляем новые изображеня
      add_more_images(params[:images])
      # flash[:warning] = "Неудачная загрузка изображений. Проверьте тип или размер файлов. Не больше 35 фото" unless @model_instance.valid? && @model_instance.save
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    #debugger
    remove_image_at_index(params[:id].to_i)
    #flash[:warning] = "Неудалось удалить изображение" unless @model_instance.save    
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end    
  end

  private

  # Проверяет корректный ли пользователь добавляет или удаляет фотографии
  def correct_user
    # т.к. у номера нет поля User, проверку на корректного пользователя для Room делаем через Hotel
    if params[:model].to_s == "Room"
      model_inst = @model_instance.hotel
    else
      model_inst = @model_instance
    end
    redirect_to root_path unless current_user?(model_inst.user) || current_user.admin?
  end

  # устанавливаем экземпляр модели которой принадлежат изображения
  def set_model_instance    
    model = params[:model] 
    if params[:action] == 'create'
      @model_instance = model.constantize.find(params[:format].to_i)
    elsif params[:action] == 'destroy'
      model_name_id = (model.downcase + '_id').to_sym
      @model_instance = model.constantize.find(params[model_name_id].to_i)
    end
  end

  # Добавление новых изображений (вынести в отдельную ф-ю)
  def add_more_images(new_images)  
    images = @model_instance.images # copy the old images
    images += new_images # concat old images with new ones
    @model_instance.images = images.uniq # add all images to model
    error_text = "Неудачная загрузка изображений. Проверьте тип или размер файлов. Не больше 35 фото"
    flash[:warning] = error_text unless @model_instance.valid? &&  @model_instance.update_attribute(:images, images.uniq)
  end

  # удаление отдельного изображения
  def remove_image_at_index(index)
    remain_images = @model_instance.images # copy the array
    deleted_image = remain_images.delete_at(index) # delete the target image
    #deleted_image.try(:remove!) # delete image from S3
    #@model_instance.images = remain_images # re-assign back
    flash[:warning] = "Неудалось удалить изображение" unless @model_instance.update_attribute(:images, remain_images)
  end

end
