require "rails_helper"

RSpec.describe "departments" do
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

  describe "show page" do
    it "shows employees name, department, their tickets oldest to newest, and their oldest ticket in a seperate location" do
      visit "/employees/#{@employee_1.id}"
      save_and_open_page
      within "#Facts" do
        expect(page).to have_content(@employee_1.name)
        expect(page).to have_content(@employee_1.department.name)
      end

      within "#Tickets" do
        expect(@ticket_2.subject).to appear_before(@ticket_1.subject)
      end

      within "#Oldest_ticket" do
        expect(page).to have_content(@ticket_2.subject)
      end
    end
  end
end
