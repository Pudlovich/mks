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
    parcel.accept!(current_user) if parcel_params[:acceptance_status] == 'accepted'
    parcel.reject!(current_user) if parcel_params[:acceptance_status] == 'rejected'
    redirect_to action: "index"
  end

  private

  def parcel_params
    params.require(:parcel).permit(:acceptance_status)
  end
end
