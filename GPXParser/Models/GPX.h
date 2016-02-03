//
//  GPX.h
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 29/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Waypoint;
@class Track;

@interface GPX : NSObject

@property (nonatomic, strong) NSArray<Waypoint *> *waypoints;
@property (nonatomic, strong) NSArray<Track *> *tracks;
@property (nonatomic, strong) NSArray<Track *> *routes;
@property (nonatomic, strong) NSString *filename;

@property (nonatomic, readonly) MKCoordinateRegion region;

+(instancetype)gpxWithWaypoints:(NSArray<Waypoint *> *)waypoints tracks:(NSArray<Track *> *)tracks andRoutes:(NSArray<Track *> *)routes;
+(instancetype)gpxWithWaypoints:(NSArray<Waypoint *> *)waypoints tracks:(NSArray<Track *> *)tracks routes:(NSArray<Track *> *)routes andFilename:(NSString *)filename;

@end
