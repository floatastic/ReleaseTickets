class Ticket
  def self.tickets_from_ids(ids)
  	tickets = []

  	ids.each { |id| tickets << Ticket.new(id) }

  	return tickets
  end

  def initialize(id)
  	@id = id
  end

  def to_s
     @id + (@title ? ": #{@title}" : '')
  end
end