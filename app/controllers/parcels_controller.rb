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
    if current_user
      @parcel.sender = current_user
    end
    if @parcel.save
      redirect_to parcels_path, notice: t('.parcel_created_succesfully')
    else
      render 'new'
    end
  end

  def show
    @parcel = Parcel.where(parcel_number: params[:parcel_number]).first!
  end

  private

  def parcel_params
    params.require(:parcel).permit(:weight, :width, :depth, :height, :name)
  end
end
