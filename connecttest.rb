require 'socket'
require 'json'

class Connector
	
	@hostname = 'localhost'
	@port = 6789
	
	def Connector.get_user_matches(id, id2)
		s = TCPSocket.open(@hostname, @port)
		a = id.to_s
		s.puts("usermatch " + a.to_s + " "  + id2.to_s)
		json = s.gets.chomp
		json = JSON.parse(json)
		matches = {}
		json.each do |key, value|
			matches[key.to_i] = value.to_f
		end
		s.close
		return matches
	end
	
	def Connector.get_society_matches(id, id2)
		s = TCPSocket.open(@hostname, @port)
		a = id.to_s
		s.puts("societymatch " + a.to_s + " "  + id2.to_s)
		json = s.gets.chomp
		json = JSON.parse(json)
		matches = {}
		json.each do |key, value|
			matches[key.to_i] = value.to_f
		end
		s.close
		return matches
	end
	
end

def test_connections
	threads = []

	40.times do |i|
		id = 1 + rand(49)
		id2 = 1 + rand(49)
		threads[i] = Thread.new {
			puts Connector.get_user_matches(id, id2)
		}
	end

	threads.each { |t| t.join }
end

def test_societies
	
end

test_connections