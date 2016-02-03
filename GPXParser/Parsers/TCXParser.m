//
//  TCXParser.m
//  TCX Reader
//
//  Created by Jelle Vandebeeck on 11/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import "TCXParser.h"

@interface TCXParser()

@property (nonatomic, strong) Fix *fix;
@property (nonatomic, strong) NSMutableArray<Track *> *tracks;

@property (nonatomic, strong) NSMutableArray<Fix *> *trackFixes;

@end

@implementation TCXParser

#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // Track
    if ([elementName isEqualToString:@"Track"]) {
		// TODO ?
	}
    
    // Track point
    if ([elementName isEqualToString:@"Position"]) {
		self.fix = [Fix new];
	}
    
    if ([elementName isEqualToString:@"LatitudeDegrees"]) {
        self.currentString = [NSMutableString new];
    }
    
    if ([elementName isEqualToString:@"LongitudeDegrees"]) {
        self.currentString = [NSMutableString new];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // End track
    if([elementName isEqualToString:@"Track"]) {
        [self.tracks addObject:[Track trackWithFixes:self.trackFixes]];
        return;
    }
    
    // End track point
    if([elementName isEqualToString:@"Position"]) {
        [self.trackFixes addObject:self.fix];
		self.fix = nil;
        return;
    }
    
    if ([elementName isEqualToString:@"LatitudeDegrees"]) {
        self.fix.latitude = [self.currentString doubleValue];
        self.currentString = nil;
    }
    
    if ([elementName isEqualToString:@"LongitudeDegrees"]) {
        self.fix.longitude = [self.currentString doubleValue];
        self.currentString = nil;
    }
}
    
@end