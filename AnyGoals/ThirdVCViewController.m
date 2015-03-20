//
//  ThirdVCViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/19/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "ThirdVCViewController.h"
#import "globalVar.h"

@interface ThirdVCViewController ()
@property (nonatomic, strong) NSArray *chartValues;

@end

@implementation ThirdVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //total Pie

    if (!self.pie) {
        self.pie = [[VBPieChart alloc] init];
        [self.view addSubview:self.pie];
    }
    [self.pie setFrame:CGRectMake(10, 50, 300, 300)];
    [self.pie setEnableStrokeColor:NO];
    [self.pie setHoleRadiusPrecent:0.8];
    
    [self.pie.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.pie.layer setShadowRadius:3];
    [self.pie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.pie.layer setShadowOpacity:0.7];
    
    
    [self.pie setHoleRadiusPrecent:0.9];
    //    [_chart setShowLabels:YES];
    
    self.chartValues = @[
                         @{@"name":@"first", @"value":@20, @"color":[UIColor blueColor]},
                         @{@"name":@"second", @"value":@20, @"color":[UIColor redColor]},

                         ];
    
    [self.pie setChartValues:_chartValues animation:YES options:VBPieChartAnimationFanAll];
    
    
    [self.downPie setEnableStrokeColor:NO];
    [self.downPie setHoleRadiusPrecent:0.8];
    
    [self.downPie setChartValues:_chartValues animation:YES options:VBPieChartAnimationFanAll];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
