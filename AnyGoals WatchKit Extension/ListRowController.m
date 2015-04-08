//
//  listRowController.m
//  AnyGoals
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "listRowController.h"

@implementation listRowController


- (instancetype)init {
    // Always call super first.
    self = [super init];
    if (self){
        // It is now safe to access interface objects.
        [self.rowTitle setText:@"Hello New World"];
    }
    NSLog(@"04");
    return self;
}
@end
