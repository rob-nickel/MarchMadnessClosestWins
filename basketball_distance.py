# To run: python3 basketball_distance.py
api_key = ""

import geopy
from geopy.distance import geodesic
import requests

def get_coordinates(location):
    url = f'https://maps.googleapis.com/maps/api/geocode/json?address={location}&key={api_key}'
    response = requests.get(url)
    data = response.json()
    if 'error_message' in data:
        raise Exception(data['error_message'])
    if 'results' in data and data['results']:
        address = data['results'][0]['geometry']['location']
        return (address['lat'], address['lng'])

def determine_closer_team(team1, team2, location):
    if team1.find("College") != -1 :
        team1_coords = get_coordinates(team1)  # (latitude, longitude)
    elif team1.find("Saint Mary") != -1:
        team1_coords = get_coordinates(team1 + "College of California")
    else:
        team1_coords = get_coordinates(team1 + " University")
    if team2.find("College") != -1 :
        team2_coords = get_coordinates(team2)  # (latitude, longitude)
    elif team2.find("Saint Mary") != -1:
        team2_coords = get_coordinates(team2 + "College of California")
    else:
        team2_coords = get_coordinates(team2 + " University")
    location_coords = get_coordinates(location)  # (latitude, longitude)

    team1_distance = geodesic(team1_coords, location_coords).miles
    team2_distance = geodesic(team2_coords, location_coords).miles

    if team1_distance < team2_distance:
        return team1
    else:
        return team2

def determine_closest_team(file_name):
    champion, location, regional_location, final_location, team1, team2, i = "", "", "", "", "", "", 0
    sweet_sixteen, final_four = [], []
    with open(file_name, 'r') as f:
        for line in f:
            if line.find("day -- ") != -1: #Location
                location = line.split(" -- ",1)[1].strip()
            elif line.find(" -- ") != -1: #Regional or Final Location
                if regional_location != "": 
                    #Compare teams at previous regional location
                    length = len(sweet_sixteen)
                    top_winner = determine_closer_team(sweet_sixteen[length-4], sweet_sixteen[length-3], regional_location)
                    bottom_winner = determine_closer_team(sweet_sixteen[length-2], sweet_sixteen[length-1], regional_location)
                    final_four.append(determine_closer_team(top_winner, bottom_winner, regional_location))
                    print(f"Final Four: {determine_closer_team(top_winner, bottom_winner, regional_location)}")
                if line.find("Final Four") != -1: #Final Location
                    final_location = line.split(" -- ",1)[1].strip()
                    top_winner = determine_closer_team(final_four[0], final_four[1], final_location)
                    bottom_winner = determine_closer_team(final_four[2], final_four[3], final_location)
                    champion=determine_closer_team(top_winner, bottom_winner, final_location)
                else:
                    regional_location = line.split(" -- ",1)[1].strip()
            elif line[0] == "(": #Game
                line =line.replace("(","").replace(")","") #Remove parentheses
                line = line.replace("0","").replace("1","").replace("2","").replace("3","").replace("4","").replace("5","").replace("6","").replace("7","").replace("8","").replace("9","")                
                team1 = line.split(",",1)[0].strip()
                team2 = line.split(",",1)[1].strip()
                #print(f"Game {team1} vs {team2} in {location}")
                if i == 0 : # First of 2 games
                    #Check which team is closer, add that team to array
                    first_winner = determine_closer_team(team1, team2, location)
                    i = 1
                elif i == 1: # Second of 2 games
                    #Check which team is closer, add to array
                    second_winner = determine_closer_team(team1, team2, location)
                    #Check last 2 teams in array against location
                    #Add winner to regional winners
                    sweet_sixteen.append(determine_closer_team(first_winner, second_winner, location))
                    print(f"Sweet Sixteen: {determine_closer_team(first_winner, second_winner, location)}")
                    i = 0

            else:
                print(f"ERROR: {line}")
            #closer_team = get_distance(team1, team2, location)
            #print(f'The closer team to {location} is {closer_team}')
            #print(f'The teams to {location}, {regional_location}, and {final_location} are {team1} and {team2}.')
    print(sweet_sixteen)
    print(f"Final Four: {final_four}")
    return champion

print(f"Champion: {determine_closest_team('data/marchMadness.txt')}!")