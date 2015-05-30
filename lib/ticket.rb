class Ticket
  attr_accessor :verified

  def self.tickets_from_ids(ids)
  	tickets = []

  	ids.each { |id| tickets << Ticket.new(id) }

  	return tickets
  end

  def initialize(id)
  	@id = id
  	@verified = false
  end

  def to_s
  	suffix = @verified ? (@title ? ": #{@title}" : '') : "(not verified)"
     @id + ": #{suffix}"
  end
end