//
//  GPX.m
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 29/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import "GPX.h"
#import "Track.h"
#import "Waypoint.h"

@implementation GPX

@synthesize region = _region;

#pragma mark - Static

+(instancetype)gpxWithWaypoints:(NSArray<Waypoint *> *)waypoints tracks:(NSArray<Track *> *)tracks andRoutes:(NSArray<Track *> *)routes{
    return [self gpxWithWaypoints:waypoints tracks:tracks routes:routes andFilename:nil];
}

+(instancetype)gpxWithWaypoints:(NSArray<Waypoint *> *)waypoints tracks:(NSArray<Track *> *)tracks routes:(NSArray<Track *> *)routes andFilename:(NSString *)filename {
    GPX *instance = [GPX new];
    instance.waypoints = waypoints;
    instance.tracks = tracks;
    instance.routes = routes;
    instance.filename = filename;
    instance->_region = MKCoordinateRegionMake(kCLLocationCoordinate2DInvalid, MKCoordinateSpanMake(0, 0));
    return instance;
}

#pragma mark - Properties

-(MKCoordinateRegion)region {
    if(!CLLocationCoordinate2DIsValid(_region.center)) {
        __block CLLocationDegrees minLat = 90.0;
        __block CLLocationDegrees maxLat = -90.0;
        __block CLLocationDegrees minLon = 180.0;
        __block CLLocationDegrees maxLon = -180.0;

        [self collectCoordinates:^(CLLocationCoordinate2D coordinate) {
            minLat = MIN(minLat, coordinate.latitude);
            minLon = MIN(minLon, coordinate.longitude);
            maxLat = MAX(maxLat, coordinate.latitude);
            maxLon = MAX(maxLon, coordinate.longitude);
        }];

        const MKCoordinateSpan span = MKCoordinateSpanMake(maxLat - minLat, maxLon - minLon);
        const CLLocationCoordinate2D center = CLLocationCoordinate2DMake((minLat + maxLat) / 2.,
                                                                         (minLon + maxLon) / 2.);
        _region = MKCoordinateRegionMake(center, span);
    }
    return _region;
}

#pragma mark - String

- (NSString *)description {
    return [NSString stringWithFormat:@"<GPX (tracks %i routes %i waypoints %i)>", _tracks.count, _routes.count, _waypoints.count];
}

#pragma mark - Helpers

-(void)collectCoordinates:(void(^)(CLLocationCoordinate2D coordinate))collector {
    for(Waypoint *waypoint in self.waypoints) {
        collector(waypoint.coordinate);
    }
    for(Track *track in self.tracks) {
        for(Fix *fix in track.fixes) {
            collector(fix.coordinate);
        }
    }
    for(Track *route in self.routes) {
        for(Fix *fix in route.fixes) {
            collector(fix.coordinate);
        }
    }
}

@end
