# -*- coding: utf-8 -*-
"""
Created on Fri Apr 28 14:20:46 2017
@author: Siddharth
"""

# Beautiful soup elaborated- https://www.crummy.com/software/BeautifulSoup/bs4/doc/
# official documnetation - https://beautiful-soup-4.readthedocs.io/en/latest/#kinds-of-objects
# Considering installing this parser, if lxml is not working-  html5lib
# Encoding can be  ASCII or UTF-8
#There are 4 main kinds of objects in BS4 beautifulsoup, Tag, Navigable string, Comment
from bs4 import BeautifulSoup
import os

os.chdir('D:/Facebook Reviews')

# Go the facebook review page of the company you want to scrape. Scroll down to include as many reviews as you want.
# Save the page as a html document. You can use Opera browser, or any other popular browser.
tf = 'Company - Reviews.html'
with open(tf,  'r', encoding='utf-8') as fp:
    tfsoup= BeautifulSoup(fp, "lxml")

# adjust class values as per html file.
#they can be obtain be "inspecting" the file with a browser
raw_reviews = tfsoup.find_all(class_='_5pbx userContent') #class for the review text
raw_date= tfsoup.find_all(class_='_5ptz') #class for review date
raw_star= tfsoup.find_all(class_='_51mq') #class for number of stars
raw_names=tfsoup.find_all(class_='fwb') #class for name of the reviewer

#the above objects are of beautiful-soup classes. They need to be converted to common python data types.

#individual field data can be accessed by
raw_reviews[0].text
raw_names[0].get("href")
#for links, doesnt seem to work very well for names, probably because using fina_all stripped the tag object
#of some information

#change to python lists
reviews=[]
for i in range(0,len(raw_reviews-1)):
    reviews[i] = str(raw_reviews[i].text)

#blending into a numpy array
#https://docs.scipy.org/doc/numpy-dev/user/quickstart.html
#import numpy as np
#table = np.column_stack(([1,2,3],[7,8,9]))
#table = np.column_stack((raw_reviews,raw_date,raw_star))
#table = np.column_stack(([1,2,3],[7,8,9]))


#links.append("http://www.sydneyairport.com.au"+flines[i+1][flines[i+1].find('reviewBody')+9:flines[i+1].find(' title')-1])
import csv

with open("FBReviews.csv", "w", newline='', encoding='utf-8') as file:
    wr = csv.writer(file)
    for item in raw_reviews:
     wr.writerow([item.text,])


l = [[1, 2], [2, 3], [4, 5]]

out = open('out.csv', 'w')
for row in l:
    for column in row:
        out.write('%d;' % column)
    out.write('\n')
out.close()
