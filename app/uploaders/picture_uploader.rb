class PictureUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  version :thumb_active, if: :resource_active?

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def store_dir
    # сохранение аватарки и фото в разных папках (mounted_as - имя поля: avatar,images)
    "uploads/#{model.class.to_s.underscore}/#{model.id}/#{mounted_as}"

    # сохранение аватарки и фото в одной папке - /Модель/ID объекта модели
    #"uploads/#{model.class.to_s.underscore}/#{model.id}"
  end  

  # Миниатюры для карусели, карточек, вывода в index
  version :thumb do
    process resize_to_fill: [225, 150]
  end

  version :thumb_active do
    process resize_to_fill: [330, 220]
  end
  
  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

private

  def resource_active? picture
    model.model_name.name == 'Active' && mounted_as.to_s == 'avatar'
  end

end
