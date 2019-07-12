#Ref - https://stackoverflow.com/questions/2637293/calculating-dawn-and-sunset-times-using-pyephem/18622944#18622944
import ephem
from datetime import datetime, time
import pytz
from nexrad_util import NEXRAD_LOCATIONS

def get_next_sunset_sunrise_time(station, date, silent=True):
    #Make an observer
    obs = ephem.Observer()

    #Provide lat, lon and elevation of radar
    sinfo = NEXRAD_LOCATIONS[station]
    obs.lat = str(sinfo['lat'])
    obs.lon = str(sinfo['lon'])
    obs.elev = sinfo['elev']

    # DateTime in UTC at local noon so that we get the right times
    noon = time(hour = 12)
    today_noon = datetime.combine(date, noon)
    tz = pytz.timezone(sinfo['tz'])
    # tz = pytz.timezone(NEXRAD_LOCATIONS['KABR']['tz'])
    today_noon_localized = tz.localize(today_noon)
    today_noon_utc = today_noon_localized.astimezone(pytz.utc)

    obs.date = today_noon_utc

    # DateTime in UTC (6 pm is to ensure its day time in US, so that we get the right sunset time)
    # obs.date = "%s 18:00:00"%(date)

    if not silent:
        print(obs.lat, obs.lon, obs.elev)
    
    #Taken from the refernce link
    #To get U.S. Naval Astronomical Almanac values, use these settings
    obs.pressure = 0
    obs.horizon = '-0:34'
    
    sun = ephem.Sun()
    
    sunset  = obs.next_setting(sun).datetime()
    sunrise = obs.next_rising(sun).datetime()
    
    return sunset, sunrise


def get_sunrise_sunset_time(station, date, silent=True):
    # Make an observer
    obs = ephem.Observer()

    # Provide lat, lon and elevation of radar
    sinfo = NEXRAD_LOCATIONS[station]
    obs.lat = str(sinfo['lat'])
    obs.lon = str(sinfo['lon'])
    obs.elev = sinfo['elev']

    # DateTime in UTC at local noon so that we get the right times
    noon = time(hour=12)
    today_noon = datetime.combine(date, noon)
    tz = pytz.timezone(sinfo['tz'])
    # tz = pytz.timezone(NEXRAD_LOCATIONS['KABR']['tz'])
    today_noon_localized = tz.localize(today_noon)
    today_noon_utc = today_noon_localized.astimezone(pytz.utc)

    obs.date = today_noon_utc

    # DateTime in UTC (6 pm is to ensure its day time in US, so that we get the right sunset time)
    # obs.date = "%s 18:00:00" % (date)

    if not silent:
        print(obs.lat, obs.lon, obs.elev)

    # Taken from the refernce link
    # To get U.S. Naval Astronomical Almanac values, use these settings
    obs.pressure = 0
    obs.horizon = '-0:34'

    sun = ephem.Sun()

    sunrise = obs.previous_rising(sun).datetime()
    sunset = obs.next_setting(sun).datetime()

    return sunrise, sunset


if __name__ == '__main__':
    print(get_next_sunset_sunrise_time('KDOX', '2010-03-01'))
