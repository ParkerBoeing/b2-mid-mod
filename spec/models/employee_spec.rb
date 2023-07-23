require "rails_helper"

RSpec.describe Employee, type: :model do
  describe "relationships" do
    it { should belong_to :department }
  end

  describe "instance methods" do
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

    it "orders tickets from oldest to newest" do
      expect(@employee_1.order_tickets_old_to_new).to eq([@ticket_2, @ticket_1])
    end

    it "returns oldest ticket" do
      expect(@employee_1.oldest_ticket).to eq(@ticket_2)
    end

    it "returns a unique list of employees affiliated through shared tickets" do
      @employee_ticket_6 = EmployeeTicket.create!(employee_id: @employee_4.id, ticket_id: @ticket_2.id)
      @employee_ticket_7 = EmployeeTicket.create!(employee_id: @employee_4.id, ticket_id: @ticket_1.id)
      expect(@employee_1.affiliated_employees).to eq([@employee_3, @employee_4])
    end
  end
end