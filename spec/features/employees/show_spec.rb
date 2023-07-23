require "rails_helper"

RSpec.describe "departments" do
  before :each do
    @department_1 = Department.create!(
      name: "Marketing",
      floor: "10th Floor")
    @department_2 = Department.create!(
      name: "IT",
      floor: "Basement")

    @employee_1 = @department_1.employees.create!(name: "George", level: 1)
    @employee_2 = @department_1.employees.create!(name: "Julia", level: 2)
    @employee_3 = @department_2.employees.create!(name: "Simon", level: 3)
    @employee_4 = @department_2.employees.create!(name: "Simone", level: 4)
    
    @ticket_1 = Ticket.create!(subject: "Get coffee", age: 3)
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
      @employee_1.reload
      within "#Facts" do
        expect(page).to have_content(@employee_1.name)
        expect(page).to have_content(@employee_1.department.name)
      end

      within "#Tickets" do
        expect(@ticket_2.subject).to appear_before(@ticket_1.subject)
        expect(page).to_not have_content(@ticket_4.subject)
        expect(page).to_not have_content(@ticket_3.subject)
      end

      within "#Oldest_ticket" do
        expect(page).to have_content(@ticket_2.subject)
      end
    end

    it "has a form to add a new ticket for the employee" do
      visit "/employees/#{@employee_1.id}"

      within "#Tickets" do
        expect(@ticket_2.subject).to appear_before(@ticket_1.subject)
        expect(page).to_not have_content(@ticket_4.subject)
      end

      within "#Add_ticket" do
        expect(page).to have_content("Please enter a valid ticket ID:")
        fill_in("ticket_id", with: @ticket_4.id)
        click_button("Submit")
        expect(current_path).to eq("/employees/#{@employee_1.id}")
      end

      within "#Tickets" do
        expect(@ticket_4.subject).to appear_before(@ticket_2.subject)
        expect(@ticket_2.subject).to appear_before(@ticket_1.subject)
        expect(page).to_not have_content(@ticket_3.subject)
      end
    end  

    it "show the employee's level and a list of all other employees that this employee shares tickets with" do
      @employee_ticket_6 = EmployeeTicket.create!(employee_id: @employee_4.id, ticket_id: @ticket_2.id)
      @employee_ticket_7 = EmployeeTicket.create!(employee_id: @employee_4.id, ticket_id: @ticket_1.id)
      visit "/employees/#{@employee_1.id}"

      within "#Facts" do
        expect(page).to have_content(@employee_1.level)
      end

      within "#Afilliated_employees" do
        expect(page).to have_content(@employee_3.name)
        expect(page).to have_content(@employee_4.name)
        expect(page).to_not have_content(@employee_4.name).twice
      end
    end
  end
end
