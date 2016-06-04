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
    unless parcel.acceptance_status == parcel_params[:acceptance_status]
      parcel.accept!(current_user) if parcel_params[:acceptance_status] == 'accepted'
      parcel.reject!(current_user) if parcel_params[:acceptance_status] == 'rejected'
    end
    redirect_to action: "index"
  end

  private

  def parcel_params
    params.require(:parcel).permit(:acceptance_status)
  end
end
