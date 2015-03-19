//
//  SecondViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (nonatomic,strong) FMDatabase *db;

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

    [self initDB];
    

    
    //total Pie
    NSNumber *totalProcess = [NSNumber numberWithInt: ([self calculateTotalProcess]*100)];
    NSMutableArray *totalProcessNumbers = [NSMutableArray array];
    [totalProcessNumbers addObject:totalProcess];
    [totalProcessNumbers addObject:[NSNumber numberWithInt:(100 - [totalProcess intValue] )]];
    
    self.totalPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
    
    self.totalPie.sliceValues = totalProcessNumbers;//must set sliceValue at the last step..
    
    
    //finished Pie
    
    NSNumber *finishedProcess = [NSNumber numberWithInt:[self calculateFinishedGoal]];
    NSMutableArray *finishedProcessNumbers = [NSMutableArray array];
    [finishedProcessNumbers addObject:finishedProcess];
    [finishedProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [finishedProcess integerValue] )]];

    

    
    self.finishPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
    

    
    self.finishPie.sliceValues = finishedProcessNumbers;//must set
    
    //urgent Pie
    
    
    
    
    NSNumber *urgentProcess = [NSNumber numberWithInt:[self calculateUrgentGoal]];
    NSMutableArray *urgentProcessNumbers = [NSMutableArray array];
    [urgentProcessNumbers addObject:urgentProcess];
    [urgentProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [urgentProcess integerValue] )]];
    
    self.urgentPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
    
    self.urgentPie.sliceValues = urgentProcessNumbers;//must set
    
    //weekly Pie
    
    NSNumber *weeklyProcess = [NSNumber numberWithInt:[self calculateWeeklyProcess]];
    NSMutableArray *weeklyProcessNumbers = [NSMutableArray array];
    [weeklyProcessNumbers addObject:weeklyProcess];
    [weeklyProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [weeklyProcess integerValue] )]];
    
    self.weeklyPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
    
    self.weeklyPie.sliceValues = weeklyProcessNumbers;//must set
    
    //monthly Pie
    
    NSNumber *monthlyProcess = [NSNumber numberWithInt:[self calculateMonthlyProcess]];
    NSMutableArray *monthlyProcessNumbers = [NSMutableArray array];
    [monthlyProcessNumbers addObject:monthlyProcess];
    [monthlyProcessNumbers addObject:[NSNumber numberWithInteger:(self.allGoals.count - [monthlyProcess integerValue] )]];
    
    self.monthlyPie.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
    
    self.monthlyPie.sliceValues = monthlyProcessNumbers;//must set
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
