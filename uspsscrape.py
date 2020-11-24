#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bs4 import BeautifulSoup
import requests
import csv
import pandas as pd

sess = requests.Session()
usps_link = "https://tools.usps.com/find-location.htm?address=60637&locationType=collectionbox&searchRadius=5&utm_source=google-my-business-url&utm_medium=search&utm_campaign=yext"

specs = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}
r = sess.get(str(usps_link), headers = specs)

if r.status_code == 200:
    soup = BeautifulSoup(r.content, "html.parser")
    print(soup.text)
    result_box = soup.find_all("p", {"class": "address"})

    for result in result_box:
        print(result.text)
else: 
    print("didn't work")