class Ticket
  attr_accessor :verified, :id, :title

  def self.tickets_from_ids(ids)
  	tickets = []

  	ids.each { |id| tickets << Ticket.new(id) }

  	return tickets
  end

  def initialize(id)
  	@id = id
  	@verified = false
  end

  def number
    return id.gsub(/^[^0-9]/, '')
  end

  def to_s
  	suffix = @verified ? (@title ? "#{@title}" : '') : "(not verified)"
    @id + ": #{suffix}"
  end
end