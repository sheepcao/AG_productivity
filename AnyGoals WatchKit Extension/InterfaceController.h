//
//  InterfaceController.h
//  AnyGoals WatchKit Extension
//
//  Created by Eric Cao on 4/8/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (weak, nonatomic) IBOutlet WKInterfaceTable *homeTable;
@property (strong, nonatomic) NSArray *elementsList;

@end
