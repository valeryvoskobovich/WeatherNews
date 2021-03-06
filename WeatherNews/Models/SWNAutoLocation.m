//
//  SWNAutoLocation.m
//  WeatherNews
//
//  Created by ValeryV on 2/8/15.
//
//

#import "SWNAutoLocation.h"
#import "SWNLocationInternal.h"
#import <Realm/Realm.h>
#import <CLLocationManager-blocks/CLLocationManager+blocks.h>

@implementation SWNAutoLocation

NSString* const kSWNAutoLocationID = @"AutoLocation";

+ (NSDictionary *)defaultPropertyValues
{
    NSMutableDictionary* values = [NSMutableDictionary dictionaryWithDictionary:[super defaultPropertyValues]];
    values[NSStringFromSelector(@selector(locationID))] = kSWNAutoLocationID;
    return [NSDictionary dictionaryWithDictionary:values];
}

- (void)setLocationID:(NSString *)locationID
{
    [super setLocationID:kSWNAutoLocationID];
}

#pragma mark -
#pragma mark SWNWeatherDisplayableItem


- (BOOL)showsLocationIcon
{
    return [CLLocationManager isLocationUpdatesAvailable];
}


@end
