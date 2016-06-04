class Employee::ParcelsController < EmployeeController

  def index
    @pending_parcels = Parcel.pending.newest_first
    @accepted_parcels = Parcel.accepted.newest_first
    @rejected_parcels = Parcel.rejected.newest_first
  end

  def edit
    @parcel = Parcel.find(params[:id])
  end

  def update
    parcel = Parcel.find(params[:id])
    service = ParcelAcceptanceService.new(parcel, parcel_params[:acceptance_status], current_user)
    if service.call
      flash[:notice] = t('.acceptance_status_changed_succesfully')
    else
      flash[:alert] = t('.acceptance_status_change_not_possible')
    end
    redirect_to action: "index"
  end

  private

  def parcel_params
    params.require(:parcel).permit(:acceptance_status)
  end
end
