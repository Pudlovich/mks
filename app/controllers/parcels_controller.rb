class ParcelsController < ApplicationController

  def index
    if current_user
      @parcels = current_user.parcels.order(created_at: :desc)
    end
  end

  def new
    @parcel = Parcel.new
  end

  def create
    @parcel = Parcel.new(parcel_params)
    if @parcel
      if current_user
        @parcel.sender = current_user
      end
      @parcel.save
      redirect_to parcels_path, notice: 'DZIAŁA!'
    else
      render 'new'
    end
  end

  def show
  end

  private

  def parcel_params
    params.require(:parcel).permit(:weight, :width, :depth, :height, :price, :name)
  end
end
