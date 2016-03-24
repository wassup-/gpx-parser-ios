//
//  Track.m
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 19/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import "Track.h"

static CLLocationDistance const kInvalidDistance = -1;

@implementation Track

@synthesize region = _region;
@synthesize distance = _distance;
@synthesize path = _path;

#pragma mark - Static

+(instancetype)trackWithFixes:(NSArray<Fix *> *)fixes {
    Track *instance = [Track new];
    instance.fixes = fixes;
    return instance;
}

#pragma mark - Properties

-(void)setFixes:(NSArray<Fix *> *)fixes {
    _fixes = fixes;

    // Invalidate cached properties
    _distance = kInvalidDistance;
    _path = nil;
    _region.center = kCLLocationCoordinate2DInvalid;
}

#pragma mark -

-(CLLocationDistance)distance {
    if(kInvalidDistance == _distance) {
        _distance = 0;
        CLLocation *prevLocation = nil;
        for(Fix *fix in self.fixes) {
            CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:fix.latitude longitude:fix.longitude];
            if(prevLocation) {
                _distance += [curLocation distanceFromLocation:prevLocation];
            }
            prevLocation = curLocation;
        }
    }
    return _distance;
}

-(MKPolyline *)path {
    if(!_path) {
        CLLocationCoordinate2D *coordinates = malloc(sizeof(CLLocationCoordinate2D) * self.fixes.count);
        for(NSUInteger i = 0; i < self.fixes.count; ++i) {
            coordinates[i] = self.fixes[i].coordinate;
        }
        _path = [MKPolyline polylineWithCoordinates:coordinates count: self.fixes.count];
        free(coordinates);
    }
    return _path;
}

-(MKCoordinateRegion)region {
    if(!CLLocationCoordinate2DIsValid(_region.center)) {
        _region = [self.class regionForCoordinates:self.fixes];
    }
    return _region;
}

#pragma mark - String

- (NSString *)description {
    return [NSString stringWithFormat:@"<Track (fixes %i)>", self.fixes.count];
}

#pragma mark - Helpers

+(MKCoordinateRegion)regionForCoordinates:(NSArray<Fix *> *)fixes {
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees maxLat = -90.0;
    CLLocationDegrees minLon = 180.0;
    CLLocationDegrees maxLon = -180.0;

    for (Fix *fix in fixes) {
        minLat = MIN(minLat, fix.latitude);
        minLon = MIN(minLon, fix.longitude);
        maxLat = MAX(maxLat, fix.latitude);
        maxLon = MAX(maxLon, fix.longitude);
    }

    const MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
    const CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.,
                                                                     (minLon + maxLon) / 2.);

    return MKCoordinateRegionMake(center, span);
}

@end
