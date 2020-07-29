import os
import re
import tmdbsimple as tmdb
tmdb.API_KEY = 'e5577e69d409c601acb98d5bfcee31c7'
search = tmdb.Search()


class Series:
    def __init__(self, id, title, year, tmdbId, path):
        self.id = id
        self.title = title
        self.sortTitle = None
        self.alternateTitles = None
        self.year = year
        self.tmdbId = tmdbId
        self.path = path
        self.overview = None
        self.poster = None
        self.fanart = None
        self.profile = None


def list_series(root_dir):
    series_class = Series
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
                    series_metadata.append(
                        series_class(
                            id=i,
                            title=series['name'],
                            year=year,
                            tmdbId=series['id'],
                            path=series_dir
                        )
                    )
                else:
                    series_metadata.append(
                        series_class(
                            id=i,
                            title=directory,
                            year=None,
                            tmdbId=None,
                            path=series_dir
                        )
                    )

    return series_metadata


print(list_series(root_dir=r"Z:\Series TV"))
