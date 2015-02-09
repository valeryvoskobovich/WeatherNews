//
//  SWNWeatherFeed.h
//  WeatherNews
//
//  Created by ValeryV on 2/8/15.
//
//

#import "RLMObject.h"
#import "SWNAutoLocation.h"
#import "RLMArray.h"

typedef void(^SWNWeatherFeedLocationCallback)(SWNLocation* location);

@interface SWNWeatherFeed : RLMObject

@property RLMArray<SWNLocation>* locations;
@property SWNAutoLocation* autoLocation;

+ (instancetype)feed;
- (void)addLocation:(SWNLocation*)location;
- (void)removeLocation:(SWNLocation*)location;

@end
