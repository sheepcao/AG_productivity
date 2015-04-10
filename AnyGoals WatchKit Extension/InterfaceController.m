//
//  InterfaceController.m
//  AnyGoals WatchKit Extension
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "InterfaceController.h"
#import "ListRowController.h"
#import "statusListInterfaceController.h"


@interface InterfaceController()

@end


@implementation InterfaceController


- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Initialize variables here.
        // Configure interface objects here.
        
        // Retrieve the data. This could be accessed from the iOS app via a shared container.
        
    }
    
    return self;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSLog(@"1111");
    
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);
    
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (IBAction)listTap {
    
    [self pushControllerWithName:@"statusListInterfaceController" context:nil];

    NSLog(@"1111111");
}
- (IBAction)statsTap {
}

@end



