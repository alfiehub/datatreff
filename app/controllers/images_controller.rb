class ImagesController < ApplicationController
  before_filter :authorize_admin

  def index
    @images = Image.all
  end

  def new
    @image = Image.new()
  end

  def create
    @image = Image.new(image_params)
    if @image.save
      redirect_to images_path
    else
      render :new
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image.update_attributes(image_params)
    redirect_to images_path
  end

  private
  def image_params
    params.require(:image).permit(:image)
  end
end
