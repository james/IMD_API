# Indices of Multiple Deprivation REST API

A simple JSON API for returning the Indices of Multiple Deprivation for a given lat long.

## Usage

Do a GET request to /imd?lat=#{lat}&lon=#{long}

An instance of this application is hosted at https://imd.abscond.org

Example hosted request: https://imd.abscond.org/imd?lat=50.96&lon=-1.17

## Installation

Running this locally requires you install sqlite3 and spacialite.

Depending on your installation of spacialite, you may need to update `@db.load_extension('mod_spatialite')` in `app.rb` with the path to where spatialite is installed.

The app is currently setup to run within the docker instance.

```
docker build -t imd_api .
docker run -p 8080:8080 imd_api
```

## Host your own

I am running this on fly.io, which can be done with `fly launch`. The app is completely self contained and can be hosted anywhere that can run the docker instance and expose port 8080 to the internet.

## The database

`imd.sqlite` contains the data in a spacialite sqlite database.

I downloaded the Shapefiles from https://communitiesopendata-communities.hub.arcgis.com/datasets/45e05901e0a14cca9ab180975e2e8194_0/explore?location=51.534487%2C-0.066772%2C13.14

I then ran: `spatialite_tool -i -shp ./Indices\ of\ Multiple\ Deprivation\ 2019/Indices_of_Multiple_Deprivation_\(IMD\)_2019 -d  imd.sqlite -t imd -s 3857 -c CP1252` to generate the data.

Important note that the data is stored in the EPSG:3857 Projected coordinate system. I found this out by running `gdalsrsinfo` on the data. To locate by lat/long I convert it to this projection.