class EmployeeTicketsController < ApplicationController
  def create
    @employee_ticket = EmployeeTicket.create!(employee_id: params[:id], ticket_id: params[:ticket_id])
    redirect_to "/employees/#{@employee_ticket.employee_id}"
  end
end