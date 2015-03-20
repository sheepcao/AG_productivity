//
//  ThirdVCViewController.h
//  AnyGoals
//
//  Created by Eric Cao on 3/19/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBPieChart.h"

@interface ThirdVCViewController : UIViewController

@property (strong, nonatomic) VBPieChart *pie;
@property (weak, nonatomic) IBOutlet VBPieChart *downPie;

@end
