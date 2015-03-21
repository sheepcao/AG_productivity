//
//  MyCustomTableViewCell.m
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "MyCustomTableViewCell.h"


@implementation MyCustomTableViewCell


-(void)setupUI
{
    if (self) {
        self.goalStatus.textAlignment = NSTextAlignmentCenter;
        
        if (![self.innerCycle superview]) {
            [self.pieView addSubview:self.innerCycle];
        }
        for (UIView *sub in self.pieView.subviews) {
            NSLog(@"subs:%@",sub);

        }
        
    }

}






@end
