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

@property (nonatomic, copy) void (^callback)(GPX *gpx, NSError *error);

@end

@implementation Parser

@synthesize gpx = _gpx;
@synthesize currentString = _currentString;

#pragma mark Initialization

+ (void)parse:(NSData *)data completion:(void(^)(GPX *, NSError *))completion {
    [[self new] parse:data completion:completion];
}

#pragma mark - Parsing

- (void)parse:(NSData *)data completion:(void(^)(GPX *, NSError *))completion {
    self.callback = completion;

    NSXMLParser *_parser = [[NSXMLParser alloc] initWithData:data];
    [_parser setDelegate:self];
    [_parser setShouldProcessNamespaces:NO];
    [_parser setShouldReportNamespacePrefixes:NO];
    [_parser setShouldResolveExternalEntities:NO];
    [_parser parse];
}

+(void)parseInBackground:(NSData *)data completion:(void (^)(GPX *, NSError *))completion {
	dispatch_queue_t background_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	__weak __typeof__(self) self_weak_ = self;
	dispatch_async(background_queue, ^{
		__strong __typeof__(self) self_strong_ = self_weak_;
		[self_strong_ parse:data completion:^(GPX *gpx, NSError *error) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completion(gpx, error);
			});
		}];
	});
}

#pragma mark - XML Parser

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if(!_currentString) self.currentString = [[NSMutableString alloc] init];

    [_currentString appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	__weak __typeof__(self) self_weak_ = self;
    dispatch_async(dispatch_get_main_queue(), ^{
		__strong __typeof__(self) self_strong_ = self_weak_;
        _callback(self_strong_.gpx, parseError);
    });
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
	__weak __typeof__(self) self_weak_ = self;
    dispatch_async(dispatch_get_main_queue(), ^{
		__strong __typeof__(self) self_strong_ = self_weak_;
        _callback(self_strong_.gpx, validError);
    });
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    _gpx = [GPX new];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	__weak __typeof__(self) self_weak_ = self;
    dispatch_async(dispatch_get_main_queue(), ^{
		__strong __typeof__(self) self_strong_ = self_weak_;
        _callback(self.gpx, nil);
    });
}

@end
