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

@end

@implementation ThirdVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //total Pie

    
    self.pie = [[PieView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, SCREEN_HEIGHT/2-50, 100, 100)];
    
    NSMutableArray *totalProcessNumbers = [NSMutableArray array];
    [totalProcessNumbers addObject:[NSNumber numberWithInt:2]];
    [totalProcessNumbers addObject:[NSNumber numberWithInt:3]];
    
    self.pie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor blueColor],[UIColor redColor]]];
    
    self.pie.sliceValues = totalProcessNumbers;//must set sliceValue at the last step..
    
    [self.view addSubview:self.pie];
    
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
