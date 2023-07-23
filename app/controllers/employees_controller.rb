class EmployeesController < ApplicationController

  def show
    @employee = Employee.find(params[:id])
    @tickets = @employee.order_tickets_old_to_new
    @affiliated_employees = @employee.affiliated_employees
  end
end

