class Employee::ParcelsController < EmployeeController

  def index
<<<<<<< HEAD
    @pending_parcels = Parcel.pending.newest_first
    @accepted_parcels = Parcel.accepted.newest_first
    @rejected_parcels = Parcel.rejected.newest_first
=======
    @parcels = Parcel.newest_first
>>>>>>> employee_parcels_controller
  end

  def edit
    @parcel = Parcel.find(params[:id])
  end

  # def update
  #   parcel = Parcel.find(params[:id])
  #   parcel.update!(parcel_params)
  #   redirect_to action: "index"
  # end

  # private

  # def parcel_params
  #   params.require(:parcel)
  # end
end
