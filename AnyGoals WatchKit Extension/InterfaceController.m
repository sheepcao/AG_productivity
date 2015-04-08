//
//  InterfaceController.m
//  AnyGoals WatchKit Extension
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "InterfaceController.h"
#import "ListRowController.h"


@interface InterfaceController()

@end


@implementation InterfaceController


- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Initialize variables here.
        // Configure interface objects here.
        
        // Retrieve the data. This could be accessed from the iOS app via a shared container.
        self.elementsList = [NSArray arrayWithObjects:@"目标列表",@"数据统计", nil];
        
        [self loadTableRows];
    }
    
    return self;
}
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSLog(@"1111");
    
    self.elementsList = [NSArray arrayWithObjects:@"目标列表",@"数据统计", nil];
    
    [self loadTableRows];
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

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    if (rowIndex == 0) {
        [self pushControllerWithName:@"goalListController" context:nil];
        NSLog(@"1");
    }else if (rowIndex == 1)
    {
        [self pushControllerWithName:@"statsController" context:nil];
        NSLog(@"2");

    }
}
- (void)loadTableRows {
    [self.homeTable setNumberOfRows:self.elementsList.count withRowType:@"default"];
    
    
    // Create all of the table rows.
    [self.elementsList enumerateObjectsUsingBlock:^(NSString *rowData, NSUInteger idx, BOOL *stop) {
        listRowController *elementRow = [self.homeTable rowControllerAtIndex:idx];
        
        [elementRow.rowName setText:rowData];
    }];
}

@end



