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
        
        
        if (!self.pie) {
            self.pie = [[VBPieChart alloc] init];
            [self.contentView addSubview:self.pie];
            [self.contentView sendSubviewToBack:self.pie];
            [self.pie setBackgroundColor:[UIColor clearColor]];
            [self.pie setFrame:CGRectMake(self.frame.size.width-42-130,self.frame.size.height/2-65,130,130)];

            self.total_Amount = [[UILabel alloc] initWithFrame:CGRectMake(self.pie.frame.size.width/2-54+self.pie.frame.origin.x, self.pie.frame.origin.y+self.pie.frame.size.height/2+3, 110, 40)];
            self.done_Amount = [[UILabel alloc] initWithFrame:CGRectMake(self.pie.frame.size.width/2-60+self.pie.frame.origin.x, self.pie.frame.origin.y+self.pie.frame.size.height/2-38, 120, 45)];


            
        }
//        [self.pie.layer setShadowOffset:CGSizeMake(0.3, 0.3)];
//        [self.pie.layer setShadowRadius:0.8];
//        [self.pie.layer setShadowColor:[UIColor blackColor].CGColor];
//        [self.pie.layer setShadowOpacity:0.65];
         self.pie.lineColor = [UIColor lightGrayColor];
        
        [self.pie setEnableStrokeColor:NO];
        [self.pie setHoleRadiusPrecent:0.88];
        
        
        self.total_Amount.font = [UIFont systemFontOfSize:25.0f];
        self.total_Amount.textAlignment = NSTextAlignmentCenter;
        [self.total_Amount setBackgroundColor:[UIColor clearColor]];
        [self.total_Amount setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:self.total_Amount];
        
        self.done_Amount.font = [UIFont systemFontOfSize:42.0f];
        self.done_Amount.textAlignment = NSTextAlignmentCenter;
        [self.done_Amount setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.done_Amount];
        
        


        
    }

}






@end
