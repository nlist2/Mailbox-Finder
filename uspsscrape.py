#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Importing BeautifulSoup, Requests, and Pandas
from bs4 import BeautifulSoup
import requests
import pandas as pd
from selenium import webdriver as driver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options

# defining the webdriver as a headless Firefox
options = Options()
options.headless = True
browser = driver.Firefox(options=options)

# Webdriver going to our link
usps_link = "https://tools.usps.com/find-location.htm?address=60637&locationType=collectionbox&searchRadius=1000"
browser.get(usps_link)

# Implicitly wait for dynamically generated addresses (requests couldn't handle the dynamically generated info from what I know)
try:
    element = WebDriverWait(browser, 5).until(
        EC.presence_of_element_located((By.CLASS_NAME, "list-item-location.popover-trigger"))
    )
    # After element is found, save the html and use BeautifulSoup to parse it
    html = browser.page_source
    soup = BeautifulSoup(html, "html.parser")

    # div with id=resultBox has the first 10 (visible results)
    result_box = soup.find("div", {"id": "resultBox"})
    for box in result_box.find_all("div", {"class": "list-item-location popover-trigger"}):
        print(box.find("p", {"class": "address"}).text + "\n" + box.find("div", {"class": "store-hours"}).text)
    
    # div with id=resultBox has the rest of the results
    result_box2 = soup.find("div", {"id": "resultBox2"})
    for box in result_box2.find_all("div", {"class": "list-item-location popover-trigger"}):
        print(box.find("p", {"class": "address"}).text + "\n" + box.find("div", {"class": "store-hours"}).text)

except:
    print("No results found.")
    
browser.quit()

