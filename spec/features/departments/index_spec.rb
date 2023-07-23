require "rails_helper"

RSpec.describe "departments" do


  describe "index page" do

    before :each do
      @department_1 = Department.create!(
        name: "Marketing",
        floor: "10th Floor")
      @department_2 = Department.create!(
        name: "IT",
        floor: "Basement")
  
      @employee_1 = @department_1.employees.create!(name: "George", level: "Intern")
      @employee_2 = @department_1.employees.create!(name: "Julia", level: "Manager")
      @employee_3 = @department_2.employees.create!(name: "Simon", level: "Junior Dev")
      @employee_4 = @department_2.employees.create!(name: "Simone", level: "Senior Dev")
      
      @ticket_1 = Ticket.create!(subject: "Get our coffee", age: 3)
      @ticket_2 = Ticket.create!(subject: "Wax shoes", age: 7)
      @ticket_3 = Ticket.create!(subject: "Performance review for intern", age: 10)
      @ticket_4 = Ticket.create!(subject: "Create linked list", age: 14)
  
      @employee_ticket_1 = EmployeeTicket.create!(employee_id: @employee_1.id, ticket_id: @ticket_1.id)
      @employee_ticket_2 = EmployeeTicket.create!(employee_id: @employee_1.id, ticket_id: @ticket_2.id)
      @employee_ticket_3 = EmployeeTicket.create!(employee_id: @employee_2.id, ticket_id: @ticket_3.id)
      @employee_ticket_4 = EmployeeTicket.create!(employee_id: @employee_3.id, ticket_id: @ticket_4.id)
      @employee_ticket_5 = EmployeeTicket.create!(employee_id: @employee_3.id, ticket_id: @ticket_1.id)
    end

    it "shows each department, the corresponding floor it is on, and all of its employees" do
      visit "/departments"

      within "#Marketing" do
        expect(page).to have_content(@department_1.name)
        expect(page).to have_content(@department_1.floor)
        expect(page).to have_content(@employee_1.name)
        expect(page).to have_content(@employee_2.name)
      end

      within "#IT" do
        expect(page).to have_content(@department_2.name)
        expect(page).to have_content(@department_2.floor)
        expect(page).to have_content(@employee_3.name)
        expect(page).to have_content(@employee_4.name)
      end
    end
  end
end
