class Employee::OperationsController < EmployeeController

  def new
    @operation = Operation.new
  end

  def create
    @operation = Operation.new(operation_params)
    if @operation.place.present? && @operation.save
      redirect_to new_employee_operation_path, notice: t('.operation_created_succesfully')
    else
      flash[:alert] = t('.no_place_provided') if @operation.place.blank?
      render 'new'
    end
  end

  private

  def operation_params
    parcel = Parcel.find_by(parcel_params)
    params.require(:operation).permit(:kind, :place, :additional_info).merge(user: current_employee, parcel: parcel)
  end

  def parcel_params
    params.require(:parcel).permit(:parcel_number)
  end
end
