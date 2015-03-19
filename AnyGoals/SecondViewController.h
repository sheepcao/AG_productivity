//
//  SecondViewController.h
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PieView.h"
#import "globalVar.h"
#import "GoalObj.h"

#import "VBPieChart.h"


@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet PieView *PiesView;
//@property (weak, nonatomic) IBOutlet PieView *totalPie;
//@property (weak, nonatomic) IBOutlet PieView *finishPie;
//@property (weak, nonatomic) IBOutlet PieView *urgentPie;
//@property (weak, nonatomic) IBOutlet PieView *weeklyPie;
//@property (weak, nonatomic) IBOutlet PieView *monthlyPie;


@property (strong, nonatomic)  VBPieChart *totalPie;
@property (strong, nonatomic)  VBPieChart *finishPie;

@property (strong, nonatomic)  VBPieChart *urgentPie;
@property (strong, nonatomic)  VBPieChart *weeklyPie;
@property (strong, nonatomic)  VBPieChart *monthlyPie;

@property (strong, nonatomic) NSMutableArray *allGoals;
@end

