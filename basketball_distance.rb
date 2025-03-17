# To run: ruby basketball_distance.rb
require 'json'
require 'net/http'
require 'uri'

AZURE_KEY = ''

# Input variables determine which direction to measure
case ARGV[0]
when 'n', 'north'
  $direction = "north"
when 's', 'south'
  $direction = "south"
when 'e', 'east'
  $direction = "east"
when 'w', 'west'
  $direction = "west"
else
  $direction = "north"
  #$direction = "east"
  #$direction = "west"
  #$direction = "south"
end

def get_coordinates(location)
  url = URI.parse("https://atlas.microsoft.com/search/poi/json?&subscription-key=#{AZURE_KEY}&api-version=1.0&query=#{location}&countrySet=US")
  response = Net::HTTP.get(url)
  data = JSON.parse(response)
  if data['error_message']
    puts "ERROR #{data['error_message']}"
    raise Exception.new(data['error_message'])
  elsif data['results'] && data['results'].length > 0
    address = data['results'][0]['position']
    #puts "#{location}: #{address['lat']}N, #{address['lon']}W"
    return [address['lat'], address['lon']]
  end
end

def determine_closer_team(team1, team2, location)
  #puts(team1 + " vs " + team2 + " in " + location)
  if team1.include? 'College'
    team1_coords = get_coordinates(team1)
  elsif team1.include? 'Saint Mary'
    team1_coords = get_coordinates(team1 + ' College of California')
  elsif team1.include? 'Wagner'
    team1_coords = get_coordinates(team2 + ' College of New York')
  else
    team1_coords = get_coordinates(team1 + ' University')
  end

  if team1_coords == nil 
    puts "AHHH"
    return team2
  end

  if team2.include? 'College'
    team2_coords = get_coordinates(team2)
  elsif team2.include? 'Saint Mary'
    team2_coords = get_coordinates(team2 + ' College of California')
  elsif team2.include? 'Wagner'
    team2_coords = get_coordinates(team2 + ' College of New York')
  else
    team2_coords = get_coordinates(team2 + ' University')
  end

  if team2_coords == nil 
    puts "OHHH"
    return team1
  end

  #location_coords = get_coordinates(location)

  #puts "#{team1} #{team1_coords[0]} #{team2} #{team2_coords[0]}"

  if $direction == "north"
    team1_distance = team1_coords[0]
    team2_distance = team2_coords[0]
    if team1_distance < team2_distance
        #puts "#{team2} beats #{team1}"
        return team2
    else
        #puts "#{team1} beats #{team2}"
        return team1
    end
  elsif $direction == "east"
    team1_distance = team1_coords[1]
    team2_distance = team2_coords[1]
    if team1_distance < team2_distance
        #puts "#{team2} beats #{team1}"
        return team2
    else
        #puts "#{team1} beats #{team2}"
        return team1
    end
  elsif $direction == "west"
    team1_distance = team1_coords[1]
    team2_distance = team2_coords[1]
    if team1_distance > team2_distance
        #puts "#{team2} beats #{team1}"
        return team2
    else
        #puts "#{team1} beats #{team2}"
        return team1
    end
  elsif $direction == "south"
    team1_distance = team1_coords[0]
    team2_distance = team2_coords[0]
    if team1_distance > team2_distance
        #puts "#{team2} beats #{team1}"
        return team2
    else
        #puts "#{team1} beats #{team2}"
        return team1
    end
  else
      return team1
  end
end

def determine_closest_team(file_name)
  champion, location, regional_location, final_location, team1, team2, first_winner, second_winner, i = '', '', '', '', '', '', '', '', 0
  sweet_sixteen, final_four = [], []

  File.open(file_name, 'r') do |f|
    f.each_line do |line|
      #puts line
      if line.include? 'day -- '
        location = line.split(' -- ', 2)[1].strip
      elsif line.include? ' -- '
        if regional_location != ''
          #puts "Error here?"
          length = sweet_sixteen.length
          top_winner = determine_closer_team(sweet_sixteen[length - 4], sweet_sixteen[length - 3], regional_location)
          bottom_winner = determine_closer_team(sweet_sixteen[length - 2], sweet_sixteen[length - 1], regional_location)
          final_four.push(determine_closer_team(top_winner, bottom_winner, regional_location))
          puts "Final Four: #{final_four[(final_four.length()-1)]}"
        end
        if line.include? 'Final Four'
          final_location = line.split(' -- ', 2)[1].strip
          top_winner = determine_closer_team(final_four[0], final_four[1], final_location)
          bottom_winner = determine_closer_team(final_four[2], final_four[3], final_location)
          champion = determine_closer_team(top_winner, bottom_winner, final_location)
        else
          regional_location = line.split(' -- ', 2)[1].strip
        end
      elsif line[0] == '('
        line = line.gsub('(', '').gsub(')', '')
        line = line.gsub(/[0-9]/, '')
        team1 = line.split(',', 2)[0].strip
        team2 = line.split(',', 2)[1].strip
        #puts "i=#{i}"
        if i == 0
          first_winner = determine_closer_team(team1, team2, location)
          i = 1
        elsif i == 1
          second_winner = determine_closer_team(team1, team2, location)
          #puts ("Teams: " + first_winner + second_winner)
          sweet_sixteen.push(determine_closer_team(first_winner, second_winner, location))
          #puts "Sweet Sixteen: #{determine_closer_team(first_winner, second_winner, location)}"
          i = 0
        end
      else
        puts "ERROR: #{line}"
      end
    end
  end
  puts sweet_sixteen
  puts "Final Four: #{final_four}"
  return champion
end

puts "Champion: #{determine_closest_team('data/marchMadness2025.txt')}!"