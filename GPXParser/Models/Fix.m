//
//  Fix.m
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 11/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import "Fix.h"

@implementation Fix

#pragma mark - Coordinates

-(CLLocationDegrees)latitude {
    return self.coordinate.latitude;
}

-(void)setLatitude:(CLLocationDegrees)latitude {
    self.coordinate.latitude = latitude;
}

-(CLLocationDegrees)longitude {
    return self.coordinate.longitude;
}

-(void)setLongitude:(CLLocationDegrees)longitude {
    self.coordinate.longitude = longitude;
}

#pragma mark - String

- (NSString *)description {
    return [NSString stringWithFormat:@"<Fix (%f %f)>", self.latitude, self.longitude];
}

@end
