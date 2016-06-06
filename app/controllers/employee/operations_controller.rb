class Employee::OperationsController < EmployeeController

  def new
    
  end

  def create

  end

  private

  def operation_params
    params.require(:operation)
  end
end
