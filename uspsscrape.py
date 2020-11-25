#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Importing BeautifulSoup, Requests, and Selenium
from bs4 import BeautifulSoup
import requests
from selenium import webdriver as driver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options
from geopy import Nominatim
import sqlite3

# Connecting to our database // found on Python's documentation
conn = sqlite3.connect('collectionBoxes.db')
c = conn.cursor()

# Initializing the geolocator to convert our addresses to lat and long
geolocator = Nominatim(user_agent="my_user_agent", timeout=3)

# defining the webdriver as a headless Firefox
options = Options()
options.headless = True
browser = driver.Firefox(options=options)

# Webdriver going to our link
usps_link = "https://tools.usps.com/find-location.htm?address=60637&locationType=collectionbox&searchRadius=1000"
browser.get(usps_link)

# Implicitly wait for dynamically generated addresses (requests couldn't handle the dynamically generated info from what I know)

element = WebDriverWait(browser, 5).until(
    EC.presence_of_element_located((By.CLASS_NAME, "list-item-location.popover-trigger"))
)
# After element is found, save the html and use BeautifulSoup to parse it
html = browser.page_source
soup = BeautifulSoup(html, "html.parser")

# div with id=resultBox has the first 10 (visible results)
result_box = soup.find("div", {"id": "resultBox"})
for box in result_box.find_all("div", {"class": "list-item-location popover-trigger"}):
    address = box.find("p", {"class": "address"}).text
    store_hours = box.find("div", {"class": "store-hours"}).text
    location = geolocator.geocode(address)

    mon_fri = store_hours.split("Fri")[1].split("Sat")[0]
    sat = store_hours.split("Sun")[0].split("Sat")[1]
    sun = store_hours.split("Sun")[1]

    #print("Latitude = {}, Longitude = {}".format(location.latitude, location.longitude))

    command = "INSERT INTO boxes (address, lat, long, mon_fri, sat, sun) VALUES (?, ?, ?, ?, ?, ?);"
    c.execute(command, (str(address), location.latitude, location.longitude, str(mon_fri), str(sat), str(sun)))
    conn.commit()
    
# div with id=resultBox has the rest of the results
result_box2 = soup.find("div", {"id": "resultBox2"})
for box in result_box2.find_all("div", {"class": "list-item-location popover-trigger"}):
    address = box.find("p", {"class": "address"}).text
    store_hours = box.find("div", {"class": "store-hours"}).text
    location = geolocator.geocode(address)

    mon_fri = store_hours.split("Fri")[1].split("Sat")[0]
    sat = store_hours.split("Sun")[0].split("Sat")[1]
    sun = store_hours.split("Sun")[1]

    #print("Latitude = {}, Longitude = {}".format(location.latitude, location.longitude))

    command = "INSERT INTO boxes (address, lat, long, mon_fri, sat, sun) VALUES (?, ?, ?, ?, ?, ?);"
    c.execute(command, (str(address), location.latitude, location.longitude, str(mon_fri), str(sat), str(sun)))
    conn.commit()
    
 
browser.quit()
conn.close()

