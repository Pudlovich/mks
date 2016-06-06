class Employee::OperationsController < EmployeeController

  def new
    @operation = Operation.new
  end

  def create
    @operation = Operation.new(operation_params)
    @operation.user = current_user if user_signed_in?
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
end
