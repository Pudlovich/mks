class Employee::ParcelsController < EmployeeController

  def index
    @parcels = Parcel.all
  end

  # def edit
  #   @parcel = Parcel.find(params[:id])
  # end

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
