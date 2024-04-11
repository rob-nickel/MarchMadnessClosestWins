# March Madness Closest Wins

Welcome to the March Madness Closest Wins project!

This repository uses Google Maps API and Cloud platform to analyze NCAA tournament locations. The Python script determines which team is closer to each game location, while the Ruby script finds the most extreme north, south, east or west teams.

### Project Overview

The goal of this project is to provide an interesting perspective on NCAA basketball tournament outcomes by examining the proximity of schools' coordinates relative to the game venues. This unique approach can help identify potential advantages or disadvantages in terms of travel time, crowd support, and other factors related to distance from home court.

### Features

* Uses Google Maps API and Cloud Platform for geolocation data
* Analyzes proximity between school coordinates and game locations using Python
* Identifies extreme directional wins (north, south, east, west) using Ruby
* Allows users to specify a direction when running the Ruby script using input parameters:
	+ `ruby basketball_distance.rb n` will find the northernmost teams.
	+ `ruby basketball_distance.rb s` will find the southernmost.
	+ `ruby basketball_distance.rb e` will find the easternmost.
	+ `ruby basketball_distance.rb w` will find the westernmost.
	+ You can also use full directions like 'north', 'south', etc.

### Requirements

To run these scripts locally, you will need to have the following installed:

1. **Python**: Version 3.x with necessary libraries like `requests` and `geopy`
2. **Ruby**: With necessary gems like `json`

Additionally, please ensure you have replaced placeholders with actual values in both Python (`basketball_distance.py`) and Ruby (`basketball_distance.rb`) files such as:

- Your own Google Maps API key
- Correct path names where necessary

If not done already, make sure all required packages are correctly set up before running either program.

### Results
If the closest team to the venue won every game, we would have a final four consisting of
- UConn from the East Region
- Houston from the South Region
- Akron from the Midwest Region
- Saint Mary's from the West Region

And the campion would be the Saint Mary's Gaels!

### File Structure

| Directory/File | Description |
| --- | --- |
| `README.md`   | This documentation    |
| `basketball_distance.py`     | Python Script        |
| `basketball_distance.rb`     | Ruby Script          |

For further details about how everything works under-the-hood feel free to explore source code provided! 
