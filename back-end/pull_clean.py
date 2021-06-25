import requests
import json
from bs4 import BeautifulSoup as bs
import os
from dotenv import load_dotenv
from cachetools import cached, TTLCache


def get_creds():
    if os.path.isfile('.env') == False:
        raise EnvFileMissingError
    else:
        username = os.environ.get('USERNAME')
        api_key = os.environ.get('API_TOKEN')
        if username == None or api_key == None:
            raise EnvVariablesError
        return username, api_key


def get_data(w):
    headers = {
        "Accept": "application/json"
    }
    response = requests.request(
        'GET',
        w,
        headers=headers,
        auth=(get_creds())
    )
    if response.status_code == 401:
        raise EnvVariablesError
    else:
        return response


def get_table(x):
    try:
        resp_content = json.loads(x.text)  # reading the response as a JSON
        # selecting which subdictionaries to use to find the table content
        content = resp_content['body']['export_view']['value']
        parsed_content = bs(content, 'lxml')
        tables = parsed_content.find_all('table', {'class': 'confluenceTable'}, {
            'data-layout': 'wide'})  # finding the table with beautiful soup
        table = tables[0]  # only one table, however it is still in a list
        return table
    except IndexError:
        raise ConfluencePageContentError


def table_data_text(table):
    rows = []
    trs = table.find_all('tr')  # finding all table rows
    header_row = [td.get_text(strip=True)
                  for td in trs[0].find_all('th')]  # header row
    if header_row:  # if there is a header row include first
        rows.append(header_row)
        trs = trs[1:]
    for tr in trs:  # for every table row
        rows.append([td.get_text(strip=True)
                    for td in tr.find_all('td')])  # data row
    return rows


def create_items(x):
    try:
        items = {}
        for index, entry in enumerate(x[1:], start=1):
            items[index] = {
                'Name':  entry[1],
                'Platform': entry[2],
                'Certification': entry[3],
                'Date': entry[4]
            }
        return items
    except IndexError:
        raise ConfluenceTableError


class Error(Exception):
    """Base class for all other exceptions"""
    pass


class EnvFileMissingError(Error):
    """Raised when the .env file is missing from the root directory

    Attributes:
        message -- explanation of error"""

    def __init__(self, message='.env file is missing from the root directory'):
        self.message = message
        super().__init__(self.message)


class ConfluencePageContentError(Error):
    """Raised when there seems to be an issue with the confluence page the data is pulled from, please check on official confluence cloud page

    Attributes:
        message -- explanation of error"""

    def __init__(self, message='issue with the confluence page the data is tryng to be pulled from, it may have been moved or is no longer in a table'):
        self.message = message
        super().__init__(self.message)


class ConfluenceTableError(Error):
    """Raised when there seems to be an issue with the confluence page table, either the table is missing some information or is the wrong table altogether

    Attributes:
        message -- explanation of error"""

    def __init__(self, message='issue with the confluence table the data is tryng to be pulled from, it may be missing some data or have been changed'):
        self.message = message
        super().__init__(self.message)


class EnvVariablesError(Error):
    """Raised when the environment variables are missing or wrong within the local .env file

    Attributes:
        message -- explanation of error"""

    def __init__(self, message='environment variables are missing or wrong within the local .env file'):
        self.message = message
        super().__init__(self.message)


@cached(cache=TTLCache(maxsize=2, ttl=3600))
def main(url):
    load_dotenv()
    response = get_data(url)
    table = get_table(response)
    list_tb = table_data_text(table)
    db = create_items(list_tb)
    return db
