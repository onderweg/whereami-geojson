//
//  LocationGetter.m
//  WhereAmI
//
//  Created by Rob Mathers on 12-08-09
//  https://github.com/robmathers/WhereAmI
//
//  Modified by G. Stevens on june 2014
//  https://github.com/onderweg/whereami-geojson
//

#import "LocationGetter.h"
#import <CoreWLAN/CoreWLAN.h>

@implementation LocationGetter

-(id)init {
    self = [super init];
    self.manager = [CLLocationManager new];
    self.manager.delegate = self;
    self.shouldExit = NO;
    self.exitCode = 1;
    
    return self;
}

-(void)printCurrentLocation {
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.distanceFilter = kCLDistanceFilterNone;
        
    if (![CLLocationManager locationServicesEnabled]) {
        IFPrint(@"Location services are not enabled, quitting.");
        self.exitCode = 1;
        self.shouldExit = 1;
        return;
    }
    else if (
             ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) ||
             ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)) {
        IFPrint(@"Location services are not authorized, quitting.");
        self.exitCode = 1;
        self.shouldExit = 1;
        return;
    }
    else {
        [self.manager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval ageInSeconds = -[newLocation.timestamp timeIntervalSinceNow];
    if (ageInSeconds > 60.0) return;   // Ignore data more than a minute old

    // Create GeoJson data structure
    NSMutableDictionary *geo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         @"Feature", @"type",
                         nil];
    
    // 'Geometry' property
    NSMutableDictionary *j_geometry = [NSMutableDictionary dictionary];
    j_geometry[@"type"] = @"Point";
    j_geometry[@"coordinates"] = @[[NSNumber numberWithFloat:newLocation.coordinate.longitude], [NSNumber numberWithFloat:newLocation.coordinate.latitude]];
    [geo setObject:j_geometry forKey:@"geometry"];
    
    // 'Properties' property
    NSMutableDictionary *j_properties = [NSMutableDictionary dictionary];
    j_properties[@"name"] = [NSString stringWithFormat:@"Timestamp: %@",
                             [NSDateFormatter localizedStringFromDate:newLocation.timestamp dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle] ];
    [geo setObject:j_properties forKey:@"properties"];
    
    // Convert object to Json string
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:geo
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    IFPrint(@"%@", jsonString);
    
    [self.manager stopUpdatingLocation];
    self.exitCode = 0;
    self.shouldExit = 1;
}

-(BOOL)isWifiEnabled {
    CWInterface *wifi = [CWInterface interface];
    return wifi.powerOn;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.manager stopUpdatingLocation];
    if ([error code] == kCLErrorLocationUnknown) {
        if (![self isWifiEnabled])
            IFPrint(@"Wi-Fi is not enabled. Please enable it to gather location data");
        else
            IFPrint(@"Location could not be determined right now. Try again later. Check if Wi-Fi is enabled.");
    }
    else if ([error code] == kCLErrorDenied) {
        IFPrint(@"Access to location services was denied. You may need to enable access in System Preferences.");
    }
    else {
        IFPrint(@"Error getting location data. %@", error);
    }
       
    self.exitCode = 1;
    self.shouldExit = 1;
}

// NSLog replacement from http://stackoverflow.com/a/3487392/1376063
void IFPrint (NSString *format, ...) {
    va_list args;
    va_start(args, format);
    
    fputs([[[NSString alloc] initWithFormat:format arguments:args] UTF8String], stdout);
    fputs("\n", stdout);
    
    va_end(args);
}


@end
