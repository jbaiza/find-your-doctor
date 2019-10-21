import csv
import json
import logging
from pathlib import Path
from functools import lru_cache

import pandas as pd
import requests

logging.basicConfig(level=logging.INFO)

API_URL = 'https://geocoder.api.here.com/6.2/geocode.json?&street={}&city={}&country=Latvija&gen=9' \
          '&app_id=Wdwou7J9CcHwv9JKHUWp&app_code=ZhWENaBcff6Kuu5QWWhYsQ'

COORDINATE_CACHE_FILE = 'coordinate_cache.json'
OUTPUT_DIR = Path('./parsed/')


def request_coordinates(street, city):
    response = requests.get(url=API_URL.format(street, city))
    try:
        coordinates = next(
            result['Location']['DisplayPosition'].values()
            for view in response.json()['Response']['View']
            for result in view['Result']
        )
    except StopIteration:
        coordinates = [0, 0]
    return list(coordinates)


@lru_cache(maxsize=None)
def get_coordinates(street, city):
    with open(COORDINATE_CACHE_FILE, mode='r+', encoding='utf-8') as file:
        cached = json.load(file)

        for cached_coordinate in cached:
            cached_street, cached_city = cached_coordinate['street'], cached_coordinate['city']
            if street == cached_street and city == cached_city:
                return cached_coordinate['coordinates']

        coordinates = request_coordinates(street, city)

        cached += [{
            'street': street,
            'city': city,
            'coordinates': coordinates
        }]

        file.seek(0)
        json.dump(cached, file)
        file.truncate()
    return coordinates


def parse_excel(excel_file):
    sheets = {
        ('Izmeklējumi', 'investigations'),
        ('Speciālisti', 'specialists'),
        ('Rehabilitācija', 'rehabilitation'),
        ('Dienas stacionārs', 'hospital'),
        ('Zobārstniecība', 'dentistry'),
    }

    for sheet_name, out_file in sheets:
        logging.info(f'parsing "{sheet_name}"')

        df = pd.read_excel(excel_file, sheet_name=sheet_name, skiprows=range(8),
                           usecols=lambda x: 'Unnamed' not in x)

        df = df.rename({
            'Latvijas reģions': 'region',
            'Pilsēta/novads': 'city',
            'Pilsēta/ novads': 'city',
            'Ārstniecības iestādes nosaukums': 'name',
            'Ārstniecības iestādes adrese': 'address',
            'Ārstniecības iestādes telefoni pacientu pierakstam': 'info',
        }, axis='columns')

        queue_columns = df.columns[5:].tolist()

        df.loc[:, queue_columns] = df.loc[:, queue_columns].applymap(lambda x: 5 if x == 0 else x)

        coordinates = pd.DataFrame(df.apply(lambda x: get_coordinates(x.address, x.city), axis=1).values.tolist(),
                                   columns=['lat', 'lon'])

        df = pd.merge(df, coordinates, left_index=True, right_index=True)

        df = df.loc[:, ['region', 'city', 'name', 'address', 'info', 'lat', 'lon'] + queue_columns]

        df.to_csv(OUTPUT_DIR / f'{out_file}.csv', index=False, quoting=csv.QUOTE_NONNUMERIC)


def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    try:
        with open(COORDINATE_CACHE_FILE, mode='r+', encoding='utf-8'):
            pass
    except FileNotFoundError:
        with open(COORDINATE_CACHE_FILE, mode='w', encoding='utf-8') as file:
            json.dump([], file)

    # todo: hardcoded -> commandline/direct download from data.gov.lv ?
    parse_excel('rindas-01092019-kopa.xlsx')


if __name__ == '__main__':
    main()
