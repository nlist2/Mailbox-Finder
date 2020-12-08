#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Importing BeautifulSoup, Requests, Selenium, Pandas, and Geopy
from bs4 import BeautifulSoup
import requests
import pandas as pd
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

# Defining the webdriver as a headless Firefox
options = Options()
options.headless = True
browser = driver.Firefox(options=options)

# Importing zipcodes from our csv file, uszips.csv courtesy of an online resource
zipcodes = pd.read_csv("uszips.csv")['zip']
zipcodes = [60604]

# Iterating through each zipcode
for zipcode in zipcodes:

    # Formatting the zipcode if it isn't 5 digits
    if(len(str(zipcode)) == 3):
        zipcode = "00" + str(zipcode)
    elif(len(str(zipcode)) == 4):
        zipcode = "0" + str(zipcode)

    # Go to zipcode link
    usps_link = "https://tools.usps.com/find-location.htm?address=" + str(zipcode) + "&locationType=collectionbox&searchRadius=50"
    browser.get(usps_link)
    print(zipcode)

    # Implicitly wait for dynamically generated addresses (requests couldn't handle the dynamically generated info from what I know)
    try:
        element = WebDriverWait(browser, 5).until(
            EC.presence_of_element_located((By.CLASS_NAME, "list-item-location.popover-trigger"))
        )
    except:
        continue

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

        try:
            command = "INSERT INTO boxes (address, lat, long, mon_fri, sat, sun) VALUES (?, ?, ?, ?, ?, ?);"
            c.execute(command, (str(address), location.latitude, location.longitude, str(mon_fri), str(sat), str(sun)))
            conn.commit()
        except AttributeError:
            pass
        
    # div with id=resultBox has the rest of the results
    result_box2 = soup.find("div", {"id": "resultBox2"})
    for box in result_box2.find_all("div", {"class": "list-item-location popover-trigger"}):
        address = box.find("p", {"class": "address"}).text
        store_hours = box.find("div", {"class": "store-hours"}).text
        location = geolocator.geocode(address)

        mon_fri = store_hours.split("Fri")[1].split("Sat")[0]
        sat = store_hours.split("Sun")[0].split("Sat")[1]
        sun = store_hours.split("Sun")[1]

        try:
            command = "INSERT INTO boxes (address, lat, long, mon_fri, sat, sun) VALUES (?, ?, ?, ?, ?, ?);"
            c.execute(command, (str(address), location.latitude, location.longitude, str(mon_fri), str(sat), str(sun)))
            conn.commit()
        except AttributeError:
            pass

browser.quit()
conn.close()

