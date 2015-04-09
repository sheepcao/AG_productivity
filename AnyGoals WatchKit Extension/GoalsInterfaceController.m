//
//  GoalsInterfaceController.m
//  AnyGoals
//
//  Created by Eric Cao on 4/9/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "GoalsInterfaceController.h"
#import "listRowController.h"
#import "globalVar.h"
#import "GoalObj.h"


@interface GoalsInterfaceController()


@property (nonatomic,strong) NSMutableArray *processingTasks;
@property (nonatomic,strong) NSMutableArray *finishedTasks;
@property (nonatomic,strong) NSMutableArray *giveupTasks;
@property (nonatomic,strong) NSMutableArray *notyetTasks;
@property (nonatomic,strong) FMDatabase *db;

@end


@implementation GoalsInterfaceController
@synthesize db;

- (instancetype)init {
    self = [super init];
    
    if (self) {
        // Initialize variables here.
        // Configure interface objects here.
       
        self.processingTasks = [[NSMutableArray alloc] init];
        self.finishedTasks = [[NSMutableArray alloc] init];
        self.notyetTasks = [[NSMutableArray alloc] init];
        self.giveupTasks = [[NSMutableArray alloc] init];
//        self.Goals = ;
        NSLog(@"07");
        
    }
    
    return self;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self setTitle:context];
    
    if ([context isEqualToString:@"In process"]) {
        [self configProcessingTasks];
        
    }
//        else if(self.goalTypeSegment.selectedSegmentIndex == 1)
//    {
//        [self configFinishedTasks];
//    }else if(self.goalTypeSegment.selectedSegmentIndex == 2)
//    {
//        [self configNotyetTasks];
//    }else if(self.goalTypeSegment.selectedSegmentIndex == 3)
//    {
//        [self configGiveupTasks];
//    }

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self loadTableRows];

}

- (void)loadTableRows {
    [self.goalsListTable setNumberOfRows:self.processingTasks.count withRowType:@"listRow"];
    
    // Create all of the table rows.
    [self.processingTasks enumerateObjectsUsingBlock:^(GoalObj *rowData, NSUInteger idx, BOOL *stop) {
        listRowController *elementRow = [self.goalsListTable rowControllerAtIndex:idx];
        
        [elementRow.rowTitle setText:rowData.goalName];
        NSLog(@"title:%@",elementRow.rowTitle);
        NSLog(@"name:%@",rowData.goalName);
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


#pragma mark task configuration

-(void)configProcessingTasks
{
    
    if (self.processingTasks.count > 0) {
        [self.processingTasks removeAllObjects];
    }
    NSURL *storeURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.sheepcao.AnyGoal"];
    NSString *docsPath = [storeURL absoluteString];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    //    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    //    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER)";
    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
    
    [db executeUpdate:createGoalTable];
    [db executeUpdate:createUrgentTable];
    
    
    NSLog(@"db path11:%@",dbPath);
    
    
    // time now...
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];
    NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
    
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName,startTime,endTime,amount,amount_DONE,lastUpdateTime,reminder,reminderNote from GOALSINFO where isFinished = ? AND startTime <= ? AND isGiveup = ?", [NSNumber numberWithInt:0],timeNow,[NSNumber numberWithInt:0]];
    while ([rs next]) {
       
        GoalObj *oneGoal = [[GoalObj alloc] init];
        
        oneGoal.goalID = [NSNumber numberWithInt: [rs intForColumn:@"goalID"]];
        
        oneGoal.goalName = [rs stringForColumn:@"goalName"];
        oneGoal.startTime = [rs stringForColumn:@"startTime"];
        oneGoal.endTime = [rs stringForColumn:@"endTime"];
        
        oneGoal.amount = [NSNumber numberWithInt: [rs intForColumn:@"amount"]];
        
        oneGoal.amount_DONE = [NSNumber numberWithInt: [rs intForColumn:@"amount_DONE"]];
        oneGoal.lastUpdateTime = [rs stringForColumn:@"lastUpdateTime"];
        oneGoal.reminder = [rs stringForColumn:@"reminder"];
        oneGoal.reminderNote = [rs stringForColumn:@"reminderNote"];
        
        
        [self.processingTasks addObject:oneGoal];
        
    }
    
    [db close];
    
}

@end



