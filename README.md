# Chicago Mailbox Mapper
CS50 Final Project - iOS application that maps out all of USPS' collection boxes.

# Overview
We created a dynamic, easy-to-use iOS application that accurately maps all of the USPS collection boxes in Chicago, along with the user's location.

# Dependencies/Languages

## Python
### Use
Used Python to scrape data for each mailbox, generate coordinates for each address, and thereby add the data to our database. To run our Python script (/ScrapeAndDatabase/uspsscrape.py), type cd ScrapeAndDatabase and then python uspsscrape.py, **assuming you have downloaded all of the dependencies listed below**. If you want mailboxes from specific Zipcodes, simply add those Zipcodes to the array called zipcodes.

### Dependencies
- Selenium - sending GET requests to USPS' server and waiting until results are dynamically generated with their JavaScript
- Beautiful Soup - parse the HTML that we receive from our GET request
- GeoPy - translating each address to Latitude and Longitude coordinated
- SQLite3 - add data for each mailbox to our database, collectionBoxes.db

## SQLite
### Use
Used to manipulate and store our data that we would later use in the actual app. Visible in collectionBoxes.db (which resides in the ScrapeAndDatabase folder)

## Swift
### Use
Swift allowed us to visualize our mailboxes in iOS application form. 
### Dependencies
- MKMapView - Swift's inherent library that allows for map visualizations
- CoreLocation - Allows for User's location to be shared and broadcasted onto the map