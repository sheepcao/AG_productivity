//
//  SecondViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "SecondViewController.h"

#define pieSize ([[UIScreen mainScreen] bounds].size.width)/3

@interface SecondViewController ()
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic, strong) NSArray *chartValues;

@end

@implementation SecondViewController

@synthesize db;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    
//}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"111111111111111111111,<<<>>>>>");
    [super viewDidAppear:animated];
    
    [self setupPies];

    [self initDB];
    

    
    //total Pie
    NSNumber *totalProcess = [NSNumber numberWithInt: ([self calculateTotalProcess]*100)];
    NSMutableArray *totalProcessNumbers = [NSMutableArray array];
    [totalProcessNumbers addObject:totalProcess];
    [totalProcessNumbers addObject:[NSNumber numberWithInt:(100 - [totalProcess intValue] )]];
    
    
    self.chartValues = @[
                         @{@"name":@"first", @"value":totalProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                         @{@"name":@"second", @"value":totalProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                         
                         ];
    
    [self.totalPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
//    
//    self.totalPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
//    
//    self.totalPie.sliceValues = totalProcessNumbers;//must set sliceValue at the last step..
    
    
    //finished Pie
    
    NSNumber *finishedProcess = [NSNumber numberWithInt:[self calculateFinishedGoal]];
    NSMutableArray *finishedProcessNumbers = [NSMutableArray array];
    [finishedProcessNumbers addObject:finishedProcess];
    [finishedProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [finishedProcess integerValue] )]];

    

    
//    self.finishPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
//    
//
//    
//    self.finishPie.sliceValues = finishedProcessNumbers;//must set
//    
    //urgent Pie
    
    self.chartValues = @[
                         @{@"name":@"first", @"value":finishedProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                         @{@"name":@"second", @"value":finishedProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                         
                         ];
    
    [self.finishPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
    
    
    NSNumber *urgentProcess = [NSNumber numberWithInt:[self calculateUrgentGoal]];
    NSMutableArray *urgentProcessNumbers = [NSMutableArray array];
    [urgentProcessNumbers addObject:urgentProcess];
    [urgentProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [urgentProcess integerValue] )]];
    
//    self.urgentPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
//    
//    self.urgentPie.sliceValues = urgentProcessNumbers;//must set
//
    
    self.chartValues = @[
                         @{@"name":@"first", @"value":urgentProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                         @{@"name":@"second", @"value":urgentProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                         
                         ];
    
    [self.urgentPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
    //weekly Pie
    
    NSNumber *weeklyProcess = [NSNumber numberWithInt:[self calculateWeeklyProcess]];
    NSMutableArray *weeklyProcessNumbers = [NSMutableArray array];
    [weeklyProcessNumbers addObject:weeklyProcess];
    [weeklyProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [weeklyProcess integerValue] )]];
    
//    self.weeklyPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
//    
//    self.weeklyPie.sliceValues = weeklyProcessNumbers;//must set
//
    
    self.chartValues = @[
                         @{@"name":@"first", @"value":weeklyProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                         @{@"name":@"second", @"value":weeklyProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                         
                         ];
    
    [self.weeklyPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
    //monthly Pie
    
    NSNumber *monthlyProcess = [NSNumber numberWithInt:[self calculateMonthlyProcess]];
    NSMutableArray *monthlyProcessNumbers = [NSMutableArray array];
    [monthlyProcessNumbers addObject:monthlyProcess];
    [monthlyProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [monthlyProcess integerValue] )]];
    
    self.chartValues = @[
                         @{@"name":@"first", @"value":monthlyProcessNumbers[0], @"color":[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f]},
                         @{@"name":@"second", @"value":monthlyProcessNumbers[1], @"color":[UIColor colorWithRed:190/255.0f green:190/255.0f blue:190/255.0f alpha:1.0f]},
                         
                         ];
    
    [self.monthlyPie setChartValues:self.chartValues animation:YES options:VBPieChartAnimationFanAll];
//    self.monthlyPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
//    
//    self.monthlyPie.sliceValues = monthlyProcessNumbers;//must set
//    
}

-(CGFloat)calculateTotalProcess
{
    CGFloat finishedAction = 0.0f;
    CGFloat totalActions = 0.0f;
    CGFloat totalRate = 0.0f;
    
    for (GoalObj *goal in self.allGoals) {
        if ([goal.isGiveup intValue] == 0) {
            CGFloat rate = [goal.amount_DONE doubleValue]/[goal.amount doubleValue];
            finishedAction = finishedAction+100*rate;
            totalActions+=100;
        }
    }
    
    totalRate = finishedAction/totalActions;
    return totalRate;
}

-(int)calculateFinishedGoal
{
    int finishedGoal = 0;
    
    for (GoalObj *goal in self.allGoals) {
        if ([goal.isFinished intValue] == 1) {
          
            finishedGoal++;
        }
    }
    
    return finishedGoal;
}

-(CGFloat)calculateWeeklyProcess
{
    int weeklyActive = 0;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];

    
    for (GoalObj *goal in self.allGoals) {
            NSDate *lastUpdateTime = [dateFormat dateFromString:goal.lastUpdateTime];
            NSTimeInterval timeByNow = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
            if (timeByNow<7*24*60*60) {
                weeklyActive++;
            }
            
        
    }
    
    return weeklyActive;
}

-(CGFloat)calculateMonthlyProcess
{
    int monthActive = 0;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    
    for (GoalObj *goal in self.allGoals) {
        NSDate *lastUpdateTime = [dateFormat dateFromString:goal.lastUpdateTime];
        NSTimeInterval timeByNow = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        if (timeByNow<30*24*60*60) {
            monthActive++;
        }
        
        
    }
    
    return monthActive;
}

-(int)calculateUrgentGoal
{
    
    int urgentGoal = 0;

    
    for (GoalObj *goal in self.allGoals) {
        
        if ([goal.isGiveup intValue] == 0) {
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSDate *startTime = [dateFormat dateFromString:goal.startTime];
            NSDate *endTime = [dateFormat dateFromString:goal.endTime];
            
            NSTimeInterval timeByNow = [[NSDate date] timeIntervalSinceDate:startTime];
            NSTimeInterval timeByEnd = [endTime timeIntervalSinceDate:startTime];
            NSTimeInterval timeRemaining = timeByEnd -timeByNow;
            
            CGFloat goalRate = ([goal.amount intValue] - [goal.amount_DONE intValue])/[goal.amount intValue];
            
            if ( timeRemaining/timeByEnd <= goalRate/1.8  ) {
                
                urgentGoal++;
                
            }
        }
    }
    
    return urgentGoal;

    
    
}



-(void)initDB
{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    if (!self.allGoals) {
        self.allGoals = [[NSMutableArray alloc] init];
    }else
    {
        [self.allGoals removeAllObjects];
    }

    FMResultSet *rs = [db executeQuery:@"select goalID,startTime,endTime,amount,amount_DONE,lastUpdateTime,isFinished,isGiveup from GOALSINFO"];
    while ([rs next]) {
        GoalObj *oneGoal = [[GoalObj alloc] init];
        oneGoal.goalID = [NSNumber numberWithInt: [rs intForColumn:@"goalID"]];
        oneGoal.startTime = [rs stringForColumn:@"startTime"];
        oneGoal.endTime = [rs stringForColumn:@"endTime"];
        oneGoal.amount = [NSNumber numberWithInt: [rs intForColumn:@"amount"]];
        oneGoal.amount_DONE = [NSNumber numberWithInt: [rs intForColumn:@"amount_DONE"]];
        oneGoal.lastUpdateTime = [rs stringForColumn:@"lastUpdateTime"];
        oneGoal.isFinished = [NSNumber numberWithInt: [rs intForColumn:@"isFinished"]];
        oneGoal.isGiveup = [NSNumber numberWithInt: [rs intForColumn:@"isGiveup"]];

        [self.allGoals addObject:oneGoal];
        
    }
    
    [db close];
    
}

-(void)setupPies
{
    if (!self.totalPie) {
        self.totalPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.totalPie];

    }
    [self.totalPie setFrame:CGRectMake(SCREEN_WIDTH/2-pieSize/2, self.PiesView.frame.size.height/2-pieSize/2, pieSize, pieSize)];
    [self.totalPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.totalPie.layer setShadowRadius:1.2];
    [self.totalPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.totalPie.layer setShadowOpacity:0.7];

    [self.totalPie setEnableStrokeColor:YES];
    [self.totalPie setHoleRadiusPrecent:0];
    
    
    if (!self.finishPie) {
        self.finishPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.finishPie];
        
    }
    [self.finishPie setFrame:CGRectMake((SCREEN_WIDTH-2*pieSize)/3, self.totalPie.frame.origin.y-pieSize-30, pieSize, pieSize)];
    [self.finishPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.finishPie.layer setShadowRadius:1.2];
    [self.finishPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.finishPie.layer setShadowOpacity:0.7];
    
    [self.finishPie setEnableStrokeColor:YES];
    [self.finishPie setHoleRadiusPrecent:0];
    
    if (!self.urgentPie) {
        self.urgentPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.urgentPie];
        
    }
    [self.urgentPie setFrame:CGRectMake(2*(SCREEN_WIDTH-2*pieSize)/3+pieSize, self.finishPie.frame.origin.y, pieSize, pieSize)];
    [self.urgentPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.urgentPie.layer setShadowRadius:1.2];
    [self.urgentPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.urgentPie.layer setShadowOpacity:0.7];
    
    [self.urgentPie setEnableStrokeColor:YES];
    [self.urgentPie setHoleRadiusPrecent:0];
    
    if (!self.weeklyPie) {
        self.weeklyPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.weeklyPie];
        
    }
    [self.weeklyPie setFrame:CGRectMake((SCREEN_WIDTH-2*pieSize)/3, self.totalPie.frame.origin.y+pieSize+30, pieSize, pieSize)];
    [self.weeklyPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.weeklyPie.layer setShadowRadius:1.2];
    [self.weeklyPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.weeklyPie.layer setShadowOpacity:0.7];
    
    [self.weeklyPie setEnableStrokeColor:YES];
    [self.weeklyPie setHoleRadiusPrecent:0];
    
    
    if (!self.monthlyPie) {
        self.monthlyPie = [[VBPieChart alloc] init];
        [self.PiesView addSubview:self.monthlyPie];
        
    }
    [self.monthlyPie setFrame:CGRectMake(2*(SCREEN_WIDTH-2*pieSize)/3+pieSize, self.weeklyPie.frame.origin.y, pieSize, pieSize)];
    [self.monthlyPie.layer setShadowOffset:CGSizeMake(0.34, 0.34)];
    [self.monthlyPie.layer setShadowRadius:1.2];
    [self.monthlyPie.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.monthlyPie.layer setShadowOpacity:0.7];
    
    [self.monthlyPie setEnableStrokeColor:YES];
    [self.monthlyPie setHoleRadiusPrecent:0];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
