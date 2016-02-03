//
//  Parser.m
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 16/02/12.
//  Copyright (c) 2012 10to1. All rights reserved.
//

#import "Parser.h"

#import <CoreLocation/CoreLocation.h>

@interface Parser ()

- (void)parse:(NSData *)data completion:(void(^)(BOOL success, GPX *gpx))completionHandler;
- (void)generatePaths;

@end

@implementation Parser

@synthesize gpx = _gpx;
@synthesize currentString = _currentString;
@synthesize callback = _callback;

#pragma mark Initialization

+ (void)parse:(NSData *)data completion:(void(^)(BOOL success, GPX *gpx))completionHandler {
    [[self new] parse:data completion:completionHandler];
}

#pragma mark - Parsing

- (void)parse:(NSData *)data completion:(void(^)(BOOL success, GPX *gpx))completionHandler {
    self.callback = completionHandler;

    NSXMLParser *_parser = [[NSXMLParser alloc] initWithData:data];
    [_parser setDelegate:self];
    [_parser setShouldProcessNamespaces:NO];
    [_parser setShouldReportNamespacePrefixes:NO];
    [_parser setShouldResolveExternalEntities:NO];
    [_parser parse];
}

#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(!_currentString) self.currentString = [[NSMutableString alloc] init];

    [_currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    dispatch_async(dispatch_get_main_queue(), ^{
        _callback(NO, nil);
    });
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
    dispatch_async(dispatch_get_main_queue(), ^{
        _callback(NO, nil);
    });
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    _gpx = [GPX new];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    dispatch_async(dispatch_get_main_queue(), ^{
        _callback(YES, self.gpx);
    });
}

@end
