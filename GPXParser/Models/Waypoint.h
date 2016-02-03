//
//  Waypoint.h
//  GPX Reader
//
//  Created by Jelle Vandebeeck on 19/01/12.
//  Copyright (c) 2012 fousa. All rights reserved.
//

#import "Fix.h"

#import <Foundation/Foundation.h>

@interface Waypoint : Fix

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;

@end
