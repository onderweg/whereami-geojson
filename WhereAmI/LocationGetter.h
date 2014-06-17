//
//  LocationGetter.h
//  WhereAmI
//
//  Created by Rob Mathers on 12-08-09.
//  Modified by G. Stevens on june 2014
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationGetter : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (nonatomic) BOOL shouldExit;
@property (nonatomic) int exitCode;

-(void)printCurrentLocation;

@end
