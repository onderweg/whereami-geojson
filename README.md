# WhereAmI-GeoJson
A quick command line tool to get your geographic coordinates in GeoJson format using the OS X [CoreLocation][] framework.

Forked from [WhereAmI][].

## Usage

Open with Finder to execute, or in the terminal. If it can determine a location, it will output current location (longitude, latitude) in *GeoJson* format (whereas the original WhereAmI displays thedata in plain text).

WhereAmI tries to get a recent location, and will not display one if it is more than a minute old (to avoid inaccurate results from CoreLocation's cached data). If it cannot get location data, it will quit and print an error message.

Example output:

	{
	  "type" : "Feature",
	  "geometry" : {
	    "type" : "Point",
	    "coordinates" : [
	      5.26,
	      52.30276
	    ]
	  },
	  "properties" : {
	    "name" : "Timestamp: 17\/06\/14 20:34:08 GMT+2"
	  }
	}

You can use [GeoJSONLint][geojsonlint] to test the output.

## Notes
This is a quick and dirty example. I make no guarantees or warranties as to its accuracy, stability or compatibility (it should work with 10.7 and 10.8, but I have only tested it on 10.7). Feel free to do with it as you wish.

[corelocation]: http://en.wikipedia.org/wiki/CoreLocation
[WhereAmI]: https://github.com/robmathers/WhereAmI
[download link]: https://github.com/robmathers/WhereAmI/releases/download/v1.02/whereami-1.02.zip
[geojsonlint]: http://geojsonlint.com/
