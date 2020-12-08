# Chicago Mailbox Mapper - README.md
CS50 Final Project - iOS application that maps out all of USPS' collection boxes.
 
# Overview
We created a dynamic, easy-to-use iOS application that accurately maps all of the USPS collection boxes in Chicago, along with the user's location.
 
# Dependencies/Languages
 
## Python
### Application
Used Python to scrape data for each mailbox, generate coordinates for each address, and thereby add the data to our database. To run our Python script (/ScrapeAndDatabase/uspsscrape.py), type cd ScrapeAndDatabase and then python uspsscrape.py, **assuming you have downloaded all of the dependencies listed below**. If you want mailboxes from specific zip codes, simply add those zip codes to the array called zipcodes.
 
### Dependencies
- **Selenium** - sending GET requests to USPS' server and waiting until results are dynamically generated with their JavaScript
- **Beautiful Soup** - parse the HTML that we receive from our GET request
- **GeoPy** - translating each address to Latitude and Longitude coordinates
- **SQLite3** - add data for each mailbox to our database, collectionBoxes.db
 
## SQLite
### Application
Used to manipulate and store our data that we would later use in the actual app. Visible in collectionBoxes.db (which resides in the ScrapeAndDatabase folder)
 
## Swift
### Application
Swift allowed us to visualize our mailboxes in iOS application form.
 
### Dependencies
- **MapKit** - Swift's inherent library that allows for map visualizations
- **CoreLocation** - Allows for user's location to be shared and broadcasted on the map
 
# Usage/File Hierarchy
**\MailboxFinder\Mailbox Finder**
   - Assets.xcassets\ contains the app’s icons and other related files
   - Base.lproj\ contains storyboard files used for UI modifications
   - FirstViewController.swift contains code for map and location functionality
   - Info.plist defines that we want the user’s location
   - MailboxData.swift contains struct of our mailbox data
   - SecondViewController.swift contains code for the feedback page of the app
**\MailboxFinder\ScrapeAndDatabase**
   - chicago.csv contains all Chicago mailbox data
   - collectionBoxes.db database generated with SQLite (accessible with third-party   software like TablePlus or by the command line using ‘sqlite3 collectionBoxes.db’)
   - uspsscrape.py contains python code necessary for scrape
   - uszips.csv contains all US zip codes (obtained from a third-party source)
 
**All folders and files not addressed were automatically generated by Swift or Xcode, and were not directly interacted with by us.**