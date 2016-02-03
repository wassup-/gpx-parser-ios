//
//  GPXParser.m
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 11/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import "GPXParser.h"

@interface GPXParser()

@property (nonatomic, strong) Waypoint *waypoint;
@property (nonatomic, strong) NSMutableArray<Track *> *tracks;
@property (nonatomic, strong) NSMutableArray<Track *> *routes;

@property (nonatomic, strong) NSMutableArray<Waypoint *> *waypoints;
@property (nonatomic, strong) NSMutableArray<Fix *> *trackFixes;
@property (nonatomic, strong) NSMutableArray<Fix *> *routeFixes;

@end

@implementation GPXParser

-(instancetype)init {
	self = [super init];
	self.waypoints = [NSMutableArray new];
	self.tracks = [NSMutableArray new];
	self.routes = [NSMutableArray new];
	return self;
}

#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // Track
    if ([elementName isEqualToString:@"trk"]) {
		self.trackFixes = [NSMutableArray new];
	}

    // Track point
    if ([elementName isEqualToString:@"trkpt"]) {
        [self.trackFixes addObject:[Fix fixWithLatitude: [[attributeDict objectForKey:@"lat"] doubleValue]
											 longitude: [[attributeDict objectForKey:@"lon"] doubleValue]]];
	}

    // Waypoint
    if ([elementName isEqualToString:@"wpt"]) {
        self.waypoint = [Waypoint new];
        self.waypoint.latitude = [[attributeDict objectForKey:@"lat"] doubleValue];;
        self.waypoint.longitude = [[attributeDict objectForKey:@"lon"] doubleValue];;
	}

    // Waypoint name
    if ([elementName isEqualToString:@"desc"] && self.waypoint) {
        self.currentString = [NSMutableString new];
    }

    // Route
    if ([elementName isEqualToString:@"rte"]) {
		self.routeFixes = [NSMutableArray new];
	}

    // Route point
    if ([elementName isEqualToString:@"rtept"]) {
		[self.routeFixes addObject:[Fix fixWithLatitude: [[attributeDict objectForKey:@"lat"] doubleValue]
											 longitude: [[attributeDict objectForKey:@"lon"] doubleValue]]];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // End track
    if([elementName isEqualToString:@"trk"]) {
        [self.tracks addObject:[Track trackWithFixes:self.trackFixes]];
        self.trackFixes = nil;
        return;
    }

    // End track point
    if([elementName isEqualToString:@"trkpt"]) {
        // TODO ?
        return;
    }

    // Waypoint name
    if ([elementName isEqualToString:@"desc"] && self.waypoint) {
        self.waypoint.name = self.currentString;
        self.currentString = nil;
    }

    // End waypoint
    if([elementName isEqualToString:@"wpt"] && self.waypoint) {
        [self.waypoints addObject:self.waypoint];
		self.waypoint = nil;
        return;
    }

    // End track
    if([elementName isEqualToString:@"rte"]) {
        [self.routes addObject:[Track trackWithFixes:self.routeFixes]];
        self.routeFixes = nil;
        return;
    }

    // End Route point
    if([elementName isEqualToString:@"rtept"]) {
        // TODO ?
        return;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.gpx = [GPX gpxWithWaypoints:self.waypoints tracks:self.tracks andRoutes:self.routes];
    [super parserDidEndDocument:parser];
}

@end
