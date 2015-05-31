require 'json'
require 'net/http'
require_relative 'ticket'

class GitTicketDataProvider
  @issue_url = '/issues/:number'

  def initialize(base_url)
  	@base_url = base_url
  end

  def add_titles_to_tickets(tickets)     
  	tickets.each { |ticket| self.add_title_to_ticket(ticket) }
  end

  def add_title_to_ticket(ticket)
  	json = json_for_ticket_number(ticket.number)
    title = json["title"]

    ticket.title = title
    ticket.verified = title != nil
  end

  def json_for_ticket_number(ticket_number)
    uri = URI("#{@base_url}/issues/#{ticket_number}")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")

    http.start do |http|
	    request = Net::HTTP::Get.new uri.request_uri
	    http.use_ssl = true
	    response = http.request request
	    case response
	      when Net::HTTPSuccess then
		    JSON.parse response.body
	    end
	  end
  end

end