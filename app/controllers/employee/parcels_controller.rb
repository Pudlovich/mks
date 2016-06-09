class Employee::ParcelsController < EmployeeController

  def index
    @pending_parcels = Parcel.pending.newest_first
    @accepted_parcels = Parcel.accepted.newest_first
    @rejected_parcels = Parcel.rejected.newest_first
    @parcels_in_transit = Parcel.in_transit.newest_first
    @delivered_parcels = Parcel.delivered.newest_first
  end

  def edit
    @parcel = Parcel.find(params[:id])
    @operations = @parcel.operations.newest_first
  end

  def update
    parcel = Parcel.find(params[:id])
    status = parcel_params[:status]
    author = current_employee
    additional_info = parcel_params[:operation][:additional_info]
    service = ParcelAcceptanceService.new(parcel, status, author, additional_info)
    if service.call
      flash[:notice] = t('.status_changed_succesfully')
    else
      flash[:alert] = t('.status_change_not_possible')
    end
    redirect_to action: "index"
  end

  private

  def parcel_params
    params.require(:parcel).permit(:status,
      operation: [:additional_info])
  end
end
