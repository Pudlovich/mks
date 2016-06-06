class Employee::OperationsController < EmployeeController

  def new
    @operation = Operation.new
  end

  def create

  end

  private

  def operation_params
    params.require(:operation)
  end
end
