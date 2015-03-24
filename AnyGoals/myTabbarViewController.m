//
//  myTabbarViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/24/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "myTabbarViewController.h"

@interface myTabbarViewController ()

@end

@implementation myTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    
    
    tabBarItem1.title = @"目标列表";
    tabBarItem2.title = @"数据统计";
    
    [tabBarItem1 setImage:[[UIImage imageNamed:@"goalList0.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem1 setSelectedImage:[[UIImage imageNamed:@"goalListt.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [tabBarItem2 setImage:[[UIImage imageNamed:@"data0.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [tabBarItem2 setSelectedImage:[[UIImage imageNamed:@"data0.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    
    
    

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
