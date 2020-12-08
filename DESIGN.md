# ChicagoMailboxMapper - DESIGN.md
CS50 Final Project - iOS application that maps out all of USPS' collection boxes in Chicago.
 
# Objective
We began working on the project with the plan to map all of the USPS’s mailboxes in the United States.
 
# Process
## Gathering data
The first step in doing so was to scrape information from the USPS’ website that would give us the addresses of collection boxes, as well as each mailbox’s pickup hours. We would also need to convert the addresses we gathered into latitude and longitude coordinates, which were necessary to display each box’s location on our map. We used Selenium to send requests to their website and Beautiful Soup to parse the HTML and gather the necessary data. We used a python package called GeoPy to translate the addresses we scraped into latitude and longitude. From there, we used a SQLite database to store each mailbox's address, coordinates and hours.
 
At this point we decided to decrease our scope from mapping the entire U.S. to just mapping Chicago. Our scrape would have taken close to 2 weeks to complete, so we decided mapping Chicago would be a more feasible goal.
 
## Implementing data into our map
Our next step was to use the information in our SQLite database to display each mailbox on our map. Our original goal was to have our program read directly from our SQLite database, that way our app would dynamically be able to display new mailboxes as we added them to the database. At this point we ran into another issue, how to integrate SQLite into Swift. We attempted to use CocoaPods, a dependency manager for Swift and Objective-C projects that can install libraries. We found a SQLite library that we wanted to install, but ultimately could not figure out how to do so. We decided at this point that it would be better to have a static database that our app would read from, that way we could build the rest of our app’s functionality without needing CocoaPods. We converted our SQLite database into a .csv file (under /ScrapeAndDatabase/chicago.csv), and then transferred that information into a struct (in /MailboxFinder/MailboxData.swift). We then iterated through this struct to display each mailbox on the map.
 
# Application Design
## UI Design
We used a Tabbed-App design in order to avoid overwhelming the user - the default Tab holds the Map and all of its properties, and the “Info” tab allows the user to directly email us from the app, if they have any issues. More clearly, once a user has clicked/tapped on one of our pins, a pop-up appears that presents the specific Mailboxes’ address and collection hours, along with an “i” icon that launches an information alert. When this alert is launched, the user has the option to click “Directions”, which then takes the user to the Maps app and presents directions for them to get to their specified collection Box.
 
## Code Design
### FirstViewController.swift
This file holds all of the code used to map out our mailboxes, set the visible region to only Chicago and map the User’s given location. To map each location, we used a Swift property called MKPointAnnotation() that places a pin at a specific location (one given by a Latitude and Longitude). For each pin, we used its Title property to display the Address, and the Subtitle property to display its Collection Hours. Importantly, to be able to customize our pins (create a callout that shows the data, an alert that allows the user to get directions to the Mailbox, and pin styling that beautifies our map by changing the UI of the pins themselves) we needed to subclass/override MKMarkerAnnotationView. The code for this begins on line 59 and is commented significantly.
 
### SecondViewController.swift
The code in this file launched the Mail application when the user clicks the “Leave Feedback” button in the Info tab. Specifically, it opens the Mail app with Eric and Noah’s emails as recipients and a default Subject of Chicago Mailbox Mapper Feedback.
 
### MailboxData.swift
Holds all of our collection box data as a struct.
 
### uspsscrape.py
Our scrape file, uspsscrape.py, uses Selenium to send a request to USPS’ website and waits until the collection box results are dynamically generated. Then, we use BeautifulSoup to parse the HTML that we’ve just received, GeoPy to convert this data to longitude and latitude, and SQLite3 to send this information to our database, collectionBoxes.db. Importantly, our scrape iterates through the array “zipcodes”, which originally held all ~40000 US Zipcodes, but now simply holds all of Chicago’s zip codes/only zip codes that we wanted. For each zip code, our Selenium driver sends a GET request to the USPS page that returns results for only that Zipcode.
 
# Caveats
Our main bug is that sometimes, our pins revert back to normal styling (our custom icon goes back to the default icon) when the map has been updated. We worked hard to fix this issue, and found that it had something to do with reuseIdentifiers, but we weren’t able to completely fix it.
