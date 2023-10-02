from time import sleep
from bs4 import BeautifulSoup as bs
import sys
from selenium import webdriver
import json

def scrap_content():
    URL = "https://bama.ir/car?priced=1"
    chrome_options = webdriver.ChromeOptions()
    chrome_options.add_argument("--incognito")
    chrome_options.add_argument('headless')
    driver = webdriver.Chrome(executable_path='CHROMEDRIVER_PATH',chrome_options=chrome_options)
    driver.get(URL)

    SCROLL_PAUSE_TIME = 1
    # Get scroll height
    last_height = driver.execute_script("return document.body.scrollHeight")
    # If you want to limit the number of scroll loads, add a limit here
    scroll_limit = 30

    count = 0
    print('Loading data from website.....')
    while True and count < scroll_limit:
        # Scroll down to bottom
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
        # Wait to load page
        sleep(SCROLL_PAUSE_TIME)
        # Calculate new scroll height and compare with last scroll height
        new_height = driver.execute_script("return document.body.scrollHeight")
        if new_height == last_height:
            break
        last_height = new_height
        count += 1
    sleep(SCROLL_PAUSE_TIME) 

    soup = bs(driver.page_source, 'html5lib')

    return soup


def print_info(cars_info_list):
    # Writing to out.txt
    with open('out.txt', 'w', encoding = 'utf-8')  as f:
        for car in cars_info_list:
            for k,v in car.items():
                f.write(k + " : " + str(v) + "\n")
            f.write("-------------"+"\n")
    
    # Writing to sample.json
    with open("sample.json", "w", encoding='utf-8') as outfile:
        outfile.write('[')
        t = 0
        for car in cars_info_list:
            if t>0:
                outfile.write(',')
            json_object = json.dumps(car, indent=6)
            outfile.write(json_object)
            t=1
        outfile.write(']')


# Getting the web-page Content
page_content = scrap_content()
top_cars = page_content.find_all('div', attrs={'class':'bama-ad-holder'})

# Deriving data
print('Processing downloaded data...')
cars_info_list=[]
for car in top_cars:
    car_info = {}
    tmp = str(car.find('p',attrs={'class':'bama-ad__title'}).text.encode(encoding="UTF-8").strip(), encoding="utf-8").split("،")    
    car_info['model'] = tmp[0]
    car_info['name'] = tmp[1]

    details = car.find('div',attrs={'class':'bama-ad__detail-row'}).find_all('span')
    car_info['year'] = int(str(details[0].text.encode(encoding="UTF-8").strip(), encoding="utf-8"))
    if car_info['year'] > 2000:
        car_info['year'] -= 621

    mileage = str(details[1].text.encode(encoding="UTF-8").strip(), encoding="utf-8").split(' ')[0]
    try:
        mileage = int(mileage.replace(",",""))
    except:
        mileage = 0
    car_info['mileage'] = mileage

    tmp = str(car.find('div',attrs={'class':'bama-ad__address'}).text.encode(encoding="UTF-8").strip(), encoding="utf-8").split("/")
    car_info['city'] = tmp[0]

    if (car.find('span',attrs={'class':'bama-ad__price'})):
        car_info['price'] = int(str(car.find('span',attrs={'class':'bama-ad__price'}).text.encode(encoding="UTF-8").strip(), encoding="utf-8").replace(",",""))
    cars_info_list.append(car_info)

print('Exporting json and txt files...')
print_info(cars_info_list)

print('Done!')
