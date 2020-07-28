import os
import json
import re
import tmdbsimple as tmdb
tmdb.API_KEY = 'e5577e69d409c601acb98d5bfcee31c7'
search = tmdb.Search()

root_dir = r"Z:\Series TV"
series_metadata = []

for i, directory_temp in enumerate(os.listdir(root_dir)):
    directory_temp2 = re.sub(r"\(\b(19|20)\d{2}\b\)", '', directory_temp).rstrip()
    directory = re.sub(r"\s\b(19|20)\d{2}\b", '', directory_temp2).rstrip()
    if directory.endswith(', The'):
        directory = 'The ' + directory.rstrip(', The')
    elif directory.endswith(', A'):
        directory = 'A ' + directory.rstrip(', A')
    series_dir = os.path.join(root_dir, directory_temp)
    if os.path.isdir(series_dir) and not directory.startswith('.'):
        series_temp = search.tv(query=directory)
        if 'results' in series_temp:
            if series_temp['total_results']:
                series = series_temp['results'][0]
                if 'first_air_date' in series:
                    year = series['first_air_date'][:4]
                else:
                    year = None
                series_metadata.append({'id': i,
                                        'title': series['name'],
                                        'year': year,
                                        'tmdbId': series['id'],
                                        'path': series_dir})
            else:
                series_metadata.append({'id': i,
                                        'title': directory,
                                        'year': None,
                                        'tmdbId': None,
                                        'path': series_dir})
series_metadata_json = json.dumps(series_metadata)
print(series_metadata_json)
