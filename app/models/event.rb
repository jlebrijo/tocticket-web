class Event < ActiveRecord::Base
  attr_accessible :address, :celebrated_at, :door_payment, :info, :name, :price, :selling_deadline, :capacity, :url
  
  belongs_to :organizer, :class_name => "User"
  has_many :tickets
  
  validates :name, :address, :price, :celebrated_at, :selling_deadline, :capacity, :presence => true
  
  # Dates validations
  validate :dates, if: (:celebrated_at and :selling_deadline)
  def dates
    if celebrated_at < Time.current
      errors.add(:celebrated_at, "Date of event should be in the future")
    end
    
    if selling_deadline < Time.current
      errors.add(:selling_deadline, "Selling deadline should be in the future")
    end
    
    if selling_deadline > celebrated_at
      msg = "Celebration date should be later or equal than selling deadline date"
      errors.add(:celebrated_at, msg)
      errors.add(:selling_deadline, msg)
    end
  end

  # Capacity validation
  validate :attendees_cannot_be_higher_than_capacity, if: :capacity
  def attendees_cannot_be_higher_than_capacity
    if capacity < total_attendees
      errors.add(:capacity, "Attendees exceed capacity")
    end
  end

  def total_attendees
    self.tickets.inject(0) { |result, ticket| result + ticket.attendees}
  end
  
  def free_capacity
    capacity - total_attendees
  end

end