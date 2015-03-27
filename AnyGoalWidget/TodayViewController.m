//
//  TodayViewController.m
//  AnyGoalWidget
//
//  Created by Eric Cao on 3/27/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(SCREEN_WIDTH, 100);

    self.pieArray = [[NSMutableArray alloc] initWithCapacity:5];
    self.midTextArray = [[NSMutableArray alloc] initWithCapacity:5];
    
    NSArray *textArray = @[NSLocalizedString(@"总进度",nil),NSLocalizedString(@"完成度",nil),NSLocalizedString(@"紧迫度",nil)];
    
    for (int i = 0; i<3; i++) {
        
        NSLog(@"screen:%f",SCREEN_WIDTH);
        VBPieChart *pie = [[VBPieChart alloc] init];
        [pie setFrame:CGRectMake(i*(SCREEN_WIDTH-30)/3 +9, 5, 90, 90)];
        [pie setBackgroundColor:[UIColor clearColor]];
        pie.lineColor = [UIColor clearColor];
        
        [pie setEnableStrokeColor:NO];
        [pie setHoleRadiusPrecent:0.88];
        
        NSArray *chartValues = @[
                                 @{@"name":@"first", @"value":@2, @"color":[UIColor colorWithRed:250/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                                 @{@"name":@"second", @"value":@3, @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                                 
                                 ];
        
        [pie setChartValues:chartValues animation:YES options:VBPieChartAnimationFanAll];
        
        
        
        UILabel *midText = [[UILabel alloc] initWithFrame:CGRectMake(0, pie.frame.size.height/2-30, pie.frame.size.width, 60)];
        midText.textAlignment = NSTextAlignmentCenter;
        midText.backgroundColor = [UIColor clearColor];
        midText.textColor = [UIColor whiteColor];
        [midText setText:textArray[i]];
        
        [pie addSubview:midText];
        [self.Backview addSubview:pie];
        
        [self.pieArray addObject:pie];
        [self.midTextArray addObject:midText];
        
    }
    
//    [self updatePies];



    NSLog(@"ads");
//    [self.allPieScroll setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
}

-(void)updatePies
{

    NSLog(@"pies:%@",self.pieArray);
    for (int i = 0; i<3; i++) {
      
        NSArray *chartValues = @[
                                 @{@"name":@"first", @"value":@2, @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                                 @{@"name":@"second", @"value":@3, @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                                 
                                 ];
        VBPieChart *vbpie = self.pieArray[i];
        
        [vbpie setChartValues:chartValues animation:YES options:VBPieChartAnimationFanAll];
        
    }
    
}

-(UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    defaultMarginInsets.bottom = 5.0;
    defaultMarginInsets.left = 26.0;

    return defaultMarginInsets;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
