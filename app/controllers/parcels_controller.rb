class ParcelsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found

  def index
    if params[:parcel_number]
      redirect_to parcel_path(params[:parcel_number])
    end
    if user_signed_in?
      @parcels = current_user.parcels.newest_first
    end
  end

  def new
    @parcel = Parcel.new
    @parcel.build_sender_info
    @parcel.build_recipient_info
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
    @operations = @parcel.operations.newest_first
  end

  private

  def parcel_params
    params.require(:parcel).permit(
      :weight, :width, :depth, :height, :name,
      sender_info_attributes: [:email, :contact_name, :zip_code, :address,
        :city, :phone_number, :company_name, :other_info, :residential],
      recipient_info_attributes: [:email, :contact_name, :zip_code, :address,
        :city, :phone_number, :company_name, :other_info, :residential])
  end

  def rescue_not_found
    redirect_to parcels_path, alert: t('errors.messages.parcel_not_found')
  end
end
