class Employee < ApplicationRecord
  belongs_to :department
  has_many :employee_tickets
  has_many :tickets, through: :employee_tickets

  def order_tickets_old_to_new
    tickets.order(age: :desc)
  end

  def oldest_ticket
    order_tickets_old_to_new[0]
  end
end