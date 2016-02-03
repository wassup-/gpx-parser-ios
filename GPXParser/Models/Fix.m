//
//  Fix.m
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 11/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import "Fix.h"

@implementation Fix

#pragma mark - Static

+(instancetype)fixWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
	return [self fixWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
}

+(instancetype)fixWithCoordinate:(CLLocationCoordinate2D)coordinate {
	Fix *instance = [Fix new];
	instance.coordinate = coordinate;
	return instance;
}

#pragma mark - Coordinates

-(CLLocationDegrees)latitude {
    return self.coordinate.latitude;
}

-(void)setLatitude:(CLLocationDegrees)latitude {
    _coordinate.latitude = latitude;
}

-(CLLocationDegrees)longitude {
    return self.coordinate.longitude;
}

-(void)setLongitude:(CLLocationDegrees)longitude {
    _coordinate.longitude = longitude;
}

#pragma mark - String

- (NSString *)description {
    return [NSString stringWithFormat:@"<Fix (%f %f)>", self.latitude, self.longitude];
}

@end
