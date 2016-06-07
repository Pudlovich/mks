class Employee::OperationsController < EmployeeController

  def new
    @operation = Operation.new
  end

  def create
    @operation = Operation.new(operation_params, user: current_employee)
    if @operation.place.present? && @operation.save?
      redirect_to new_employee_operation_path, notice: t('.operation_created_succesfully')
    else
      render 'new'
    end
  end

  private

  def operation_params
    params.require(:operation).permit(:kind, :place, :additional_info)
  end

  def parcel_number
    params.require(:parcel_number)
  end
end
