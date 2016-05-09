class ParcelsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found

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
    @parcel.sender = current_user if user_signed_in?
    if @parcel.save
      redirect_to parcel_path(@parcel.parcel_number), notice: t('.parcel_created_succesfully')
    else
      render 'new'
    end
  end

  def show
    @parcel = Parcel.find_by!(parcel_number: params[:parcel_number])
  end

  private

  def parcel_params
    params.require(:parcel).permit(:weight, :width, :depth, :height, :name)
  end

  def rescue_not_found
    redirect_to parcels_path, alert: t('errors.messages.parcel_not_found')
  end
end
