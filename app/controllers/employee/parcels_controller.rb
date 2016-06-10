class Employee::ParcelsController < EmployeeController

  def index
    if parcel = Parcel.find_by(parcel_number: params[:parcel_number])
      redirect_to edit_employee_parcel_path(parcel)
    end
    @pending_parcels = Parcel.pending.newest_first.paginate(page: params[:pending], per_page: 10)
    @accepted_parcels = Parcel.accepted.newest_first.paginate(page: params[:accepted], per_page: 10)
    @rejected_parcels = Parcel.rejected.newest_first.paginate(page: params[:rejected], per_page: 10)
    @parcels_in_transit = Parcel.in_transit.newest_first.paginate(page: params[:in_transit], per_page: 10)
    @delivered_parcels = Parcel.delivered.newest_first.paginate(page: params[:delivered], per_page: 10)
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
