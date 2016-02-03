//
//  Track.h
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 19/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import "Fix.h"

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Track : NSObject

@property (nonatomic, strong) NSArray<Fix *> *fixes;

@property (nonatomic, readonly) MKPolyline *path;

@property (nonatomic, readonly) CLLocationDistance distance;
@property (nonatomic, readonly) MKCoordinateRegion region;

+(instancetype)trackWithFixes:(NSArray<Fix *> *)fixes;

@end
