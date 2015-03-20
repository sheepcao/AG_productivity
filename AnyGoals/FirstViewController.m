
//
//  FirstViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "FirstViewController.h"
#import "MyCustomTableViewCell.h"
#import "addGoalViewController.h"
#import "ATCTransitioningDelegate.h"
#import "GoalObj.h"

@interface FirstViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) ATCTransitioningDelegate *atcTD;
@property (nonatomic,strong) NSIndexPath *deletingCellIndexPath;
@property (nonatomic,strong) NSIndexPath *giveupCellIndexPath;
@property (nonatomic,strong) NSIndexPath *recoverCellIndexPath;


//@property (nonatomic,strong) UILabel *finishTime;
@end

@implementation FirstViewController

@synthesize db;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.processingTasks = [[NSMutableArray alloc] init];
    self.finishedTasks = [[NSMutableArray alloc] init];
    self.notyetTasks = [[NSMutableArray alloc] init];
    self.giveupTasks = [[NSMutableArray alloc] init];



    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //判断滑动图是否出现过，第一次调用时“isScrollViewAppear” 这个key 对应的值是nil，会进入if中
    if (![@"YES" isEqualToString:[userDefaults objectForKey:@"isScrollViewAppear"]]) {
        
        [self showScrollView];//显示滑动图
    }else
    {
        [self.tabBarController.tabBar setHidden:NO];

    }
    
    
    
}

//-(void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    [self configTasks];
//    [self.tableView reloadData];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.goalTypeSegment.selectedSegmentIndex == 0) {
        [self configProcessingTasks];

    }else if(self.goalTypeSegment.selectedSegmentIndex == 1)
    {
        [self configFinishedTasks];
    }else if(self.goalTypeSegment.selectedSegmentIndex == 2)
    {
        [self configNotyetTasks];
    }else if(self.goalTypeSegment.selectedSegmentIndex == 3)
    {
        [self configGiveupTasks];
    }
    [self.tableView reloadData];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}


#pragma mark TEACHING page
-(void) showScrollView{
    
    UIScrollView *_scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    
    
    //设置UIScrollView 的显示内容的尺寸，有n张图要显示，就设置 屏幕宽度*n ，这里假设要显示4张图
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 4, [UIScreen mainScreen].bounds.size.height);
    
    _scrollView.tag = 101;
    
    //设置翻页效果，不允许反弹，不显示水平滑动条，设置代理为自己
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    //在UIScrollView 上加入 UIImageView
    for (int i = 0 ; i < 4; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * i , 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        //将要加载的图片放入imageView 中
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        imageView.image = image;
        
        [_scrollView addSubview:imageView];
    }
    
    //初始化 UIPageControl 和 _scrollView 显示在 同一个页面中
    UIPageControl *pageConteol = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-25, self.view.frame.size.height - 70 - 49, 50, 40)];
    pageConteol.numberOfPages = 4;//设置pageConteol 的page 和 _scrollView 上的图片一样多
    pageConteol.tag = 201;
    pageConteol.pageIndicatorTintColor = [UIColor grayColor];
    pageConteol.currentPageIndicatorTintColor = [UIColor blackColor];
    
    
    UIButton *startNow = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-40, pageConteol.frame.origin.y+pageConteol.frame.size.height+5, 80, 40)];
    
    [startNow setImage:[UIImage imageNamed:@"startNow"] forState:UIControlStateNormal];
    [startNow addTarget:self action:@selector(scrollViewDisappear:) forControlEvents:UIControlEventTouchUpInside];
    startNow.tag = 301;
    
    [self.view addSubview:_scrollView];
    [self.view addSubview: pageConteol];
    [self.view addSubview:startNow];

}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    page.currentPage = current;
    
    UIButton *button = (UIButton *)[self.view viewWithTag:301];

    //当显示到最后一页时，让滑动图消失
    if (page.currentPage == 3) {
        

        [button setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
        
        //调用方法，使滑动图消失
//        [self scrollViewDisappear];
    }else
    {
        [button setImage:[UIImage imageNamed:@"startNow"] forState:UIControlStateNormal];

    }
}


-(void)scrollViewDisappear:(UIButton *)sender{
    
    //拿到 view 中的 UIScrollView 和 UIPageControl
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    
    
    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:0.6f animations:^{
        
//        scrollView.center = CGPointMake(self.view.frame.size.width/2, 1.5 * self.view.frame.size.height);
        scrollView.alpha = 0.1;
        page.alpha = 0.1;
        sender.alpha = 0.1;
        [sender removeFromSuperview];

        
    } completion:^(BOOL finished) {
        [self.tabBarController.tabBar setHidden:NO];

        [scrollView removeFromSuperview];
        [page removeFromSuperview];
        if (sender.superview) {
            [sender removeFromSuperview];

        }

    }];
    
    //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
}


#pragma mark task configuration

-(void)configProcessingTasks
{
    
    if (self.processingTasks.count > 0) {
        [self.processingTasks removeAllObjects];
    }

    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER)";
    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
    
    [db executeUpdate:createGoalTable];
    [db executeUpdate:createUrgentTable];


    NSLog(@"db path:%@",dbPath);
    
    
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

-(void)configFinishedTasks
{
    
    if (self.finishedTasks.count > 0) {
        [self.finishedTasks removeAllObjects];
    }
    
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER)";
    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
    
    [db executeUpdate:createGoalTable];
    [db executeUpdate:createUrgentTable];
    
    
    NSLog(@"db path:%@",dbPath);
    
    
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
    
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName,startTime,endTime,amount,amount_DONE,lastUpdateTime,reminder,reminderNote from GOALSINFO where isFinished = ? AND startTime <= ? AND isGiveup = ?", [NSNumber numberWithInt:1],timeNow, [NSNumber numberWithInt:0]];
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

        [self.finishedTasks addObject:oneGoal];
        
    }
    
    [db close];
    
}

-(void)configNotyetTasks
{
    
    if (self.notyetTasks.count > 0) {
        [self.notyetTasks removeAllObjects];
    }
    
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER)";
    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
    
    [db executeUpdate:createGoalTable];
    [db executeUpdate:createUrgentTable];
    
    
    NSLog(@"db path:%@",dbPath);
    
    
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
    
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName,startTime,endTime,amount,amount_DONE,lastUpdateTime,reminder,reminderNote from GOALSINFO where startTime > ? AND isGiveup = ?",timeNow,[NSNumber numberWithInt:0]];
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

        [self.notyetTasks addObject:oneGoal];
        
    }
    
    [db close];
    
}


-(void)configGiveupTasks
{
    
    if (self.giveupTasks.count > 0) {
        [self.giveupTasks removeAllObjects];
    }
    
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
    db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *createGoalTable = @"CREATE TABLE IF NOT EXISTS GOALSINFO (goalID INTEGER PRIMARY KEY AUTOINCREMENT,goalName TEXT,startTime TEXT,endTime TEXT,amount INTEGER,amount_DONE INTEGER,lastUpdateTime TEXT,reminder TEXT,reminderNote TEXT,isFinished INTEGER,isGiveup INTEGER)";
    NSString *createUrgentTable = @"CREATE TABLE IF NOT EXISTS URGENTGOALS (urgentID INTEGER PRIMARY KEY AUTOINCREMENT,goalID INTEGER)";
    
    [db executeUpdate:createGoalTable];
    [db executeUpdate:createUrgentTable];
    
    
    NSLog(@"db path:%@",dbPath);
    
    

    
    
    FMResultSet *rs = [db executeQuery:@"select goalID,goalName,startTime,endTime,amount,amount_DONE,lastUpdateTime,reminder,reminderNote from GOALSINFO where isGiveup = ?",[NSNumber numberWithInt:1]];
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

        [self.giveupTasks addObject:oneGoal];
        
    }
    
    [db close];
    
}

-(void)updateDataForTable:(NSString *)tableName setColomn:(NSString *)toColomn toData:(id)dstData whereColomn:(NSString *)strColomn isData:(id)strData
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *sqlCommand = [NSString stringWithFormat:@"update %@ set %@=%@ where %@=%@",tableName,toColomn,dstData,strColomn,strData];
    
    BOOL sql = [db executeUpdate:sqlCommand];
    if (!sql) {
        NSLog(@"ERROR: %d - %@", db.lastErrorCode, db.lastErrorMessage);
    }
    [db close];

}

-(void)deleteDataForTable:(NSString *)tableName whereColomn:(NSString *)strColomn isData:(id)strData
{
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *sqlCommand = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%@",tableName,strColomn,strData];
    
    BOOL sql = [db executeUpdate:sqlCommand];
    if (!sql) {
        NSLog(@"ERROR: %d - %@", db.lastErrorCode, db.lastErrorMessage);
    }
    [db close];
    
}


-(int)checkGoalStatus:(GoalObj *)goal
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *startTime = [dateFormat dateFromString:goal.startTime];
    NSDate *endTime = [dateFormat dateFromString:goal.endTime];
    
    NSTimeInterval timeByNow = [[NSDate date] timeIntervalSinceDate:startTime];
    NSTimeInterval timeByEnd = [endTime timeIntervalSinceDate:startTime];
    NSTimeInterval timeRemaining = timeByEnd -timeByNow;
    
    CGFloat goalRate = ([goal.amount intValue] - [goal.amount_DONE intValue])/[goal.amount intValue];
    
    if ( timeRemaining/timeByEnd <= goalRate/1.8  ) {
        
        return 3; //represent urgent goal...
        
    }else if(goalRate <= (timeRemaining/timeByEnd)/1.8)
    {
        return 2; //represent super processed goal...

    }else
    {
        return 1; //represent normal goal...
        
    }
    

}


-(int)checkProcess:(GoalObj *)goal
{
   
    CGFloat rate = [goal.amount_DONE doubleValue]/[goal.amount doubleValue];
    
    if ( rate<1/3.0f) {
        
        return 1; //represent initial stage goal...
        
    }else if((rate>= 1/3.0f )&& (rate <= 2/3.0f))
    {
        return 2; //represent Mid stage goal...
        
    }else
    {
        return 3; //represent final stage goal...
        
    }
    
    
}



#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger rows = 0;
    if (self.goalTypeSegment.selectedSegmentIndex == 0) {
        rows = [self.processingTasks count];
    }else if (self.goalTypeSegment.selectedSegmentIndex == 1) {
        rows = [self.finishedTasks count];
    }else if (self.goalTypeSegment.selectedSegmentIndex == 2) {
        rows = [self.notyetTasks count];
    }else if (self.goalTypeSegment.selectedSegmentIndex == 3) {
        rows = [self.giveupTasks count];
    }
 
    return rows;

}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (self.goalTypeSegment.selectedSegmentIndex == 0) {
       
        return [self prepareCellForSegZero:indexPath];
        
    }else
    {
        return [self prepareCellForSegFirst:indexPath];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.goalTypeSegment.selectedSegmentIndex == 1 || self.goalTypeSegment.selectedSegmentIndex == 3) {
        return;
    }

    
    
    GoalObj *goal;
    addGoalViewController *addNewGoal = [[addGoalViewController alloc] initWithNibName:@"addGoalViewController" bundle:nil];
    
    addNewGoal.isNewGoal = false;
    
    if (self.goalTypeSegment.selectedSegmentIndex == 0) {
        goal = self.processingTasks[indexPath.row];
    }else if (self.goalTypeSegment.selectedSegmentIndex == 2)
    {
        goal = self.notyetTasks[indexPath.row];
    }
    
    addNewGoal.editingGoal = goal;

    
    [self setupTransitioningDelegate];
    
    [self.navigationController pushViewController:addNewGoal animated:YES];
}

-(UITableViewCell *)prepareCellForSegZero:(NSIndexPath*)indexPath
{
    NSString *cellIdentifier = @"MyCustomCell";

    MyCustomTableViewCell *cell = (MyCustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                                forIndexPath:indexPath];
    
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:80.0f];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:80.0f];
    cell.delegate = self;
    [cell setupUI];
    
    GoalObj *goal =self.processingTasks[indexPath.row];
    
    cell.GoalName.text = goal.goalName;
    cell.updateTime.text = goal.lastUpdateTime;
    [cell.totalAmount setText:[NSString stringWithFormat:@"%@",goal.amount]];
    [cell.doneAmount setText:[NSString stringWithFormat:@"%@",goal.amount_DONE]];
    [cell.updateTime setHidden:NO];
    [cell.pieView setHidden:NO];
    [cell.statusShow setHidden:NO];
    [cell.reminderShow setHidden:NO];
    [cell.timeLabel setHidden:YES];
    [cell.timeSpecific setHidden:YES];
    

    NSMutableArray *GoalProcessNumbers = [NSMutableArray array];
    [GoalProcessNumbers addObject:goal.amount_DONE];
    [GoalProcessNumbers addObject:[NSNumber numberWithInt:([goal.amount intValue] - [goal.amount_DONE intValue] )]];

    
    
    int goalStatus = [self checkProcess:goal];
    switch (goalStatus) {
        case 1:
            cell.pieView.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:250/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
            cell.doneAmount.textColor = [UIColor colorWithRed:250/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f];
            break;
        case 2:
            cell.pieView.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:255/255.0f green:200/255.0f blue:100/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
            cell.doneAmount.textColor = [UIColor colorWithRed:255/255.0f green:200/255.0f blue:100/255.0f alpha:1.0f];

            break;
        case 3:
            cell.pieView.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
            cell.doneAmount.textColor = [UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f];

            break;
            
        default:
            break;
    }

    cell.pieView.sliceValues = GoalProcessNumbers;//must set sliceValue at the last step..
//
    int goalUrgent = [self checkGoalStatus:goal];
    switch (goalUrgent) {
        case 1:
            [cell.statusShow setImage:[UIImage imageNamed:@"1.png"]];
            break;
        case 2:
            [cell.statusShow setImage:[UIImage imageNamed:@"2.png"]];
            break;
        case 3:
            
            [cell.statusShow setImage:[UIImage imageNamed:@"0.png"]];
            break;
            
        default:
            break;
    }

    NSLog(@"goal.reminder :%@",goal.reminder );
    [goal.reminder isEqualToString:@""]?[cell.reminderShow setImage:[UIImage imageNamed:@"3"]]:[cell.reminderShow setImage:[UIImage imageNamed:@"1"]];
    
    
    
    return cell;

}


-(UITableViewCell *)prepareCellForSegFirst:(NSIndexPath*)indexPath
{
    NSString *cellIdentifier = @"MyCustomCell";
    
    MyCustomTableViewCell *cell = (MyCustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                                forIndexPath:indexPath];
    
    cell.delegate = self;
    [cell setupUI];

    [cell setLeftUtilityButtons:nil WithButtonWidth:80.0f];

    
    GoalObj *goal ;

    if(self.goalTypeSegment.selectedSegmentIndex ==1)
    {
        [cell setRightUtilityButtons:[self oneRightButtons] WithButtonWidth:80.0f];

        goal = self.finishedTasks[indexPath.row];
        cell.timeLabel.text = @"完成时间";
        cell.timeSpecific.text = goal.lastUpdateTime;
    }else if(self.goalTypeSegment.selectedSegmentIndex ==2)
    {
        [cell setRightUtilityButtons:[self oneRightButtons] WithButtonWidth:80.0f];

        goal = self.notyetTasks[indexPath.row];

        cell.timeLabel.text = @"开始时间";
        cell.timeSpecific.text = goal.startTime;
        
    }else if(self.goalTypeSegment.selectedSegmentIndex ==3)
    {
        [cell setRightUtilityButtons:[self twoRightButtons] WithButtonWidth:80.0f];

        goal = self.giveupTasks[indexPath.row];

        cell.timeLabel.text = @"放弃时间";
        cell.timeSpecific.text = goal.lastUpdateTime;
        
    }
    [cell.updateTime setHidden:YES];

    [cell.timeLabel setHidden:NO];
    [cell.timeSpecific setHidden:NO];
    
    cell.GoalName.text = goal.goalName;
    cell.updateTime.text = goal.lastUpdateTime;

    [cell.totalAmount setText:[NSString stringWithFormat:@"%@",goal.amount]];
    [cell.doneAmount setText:[NSString stringWithFormat:@"%@",goal.amount_DONE]];
    [cell.pieView setHidden:NO];
    [cell.reminderShow setHidden:YES];
    [cell.statusShow setHidden:YES];
    
    //add finish time
    
    
    

    
    NSMutableArray *GoalProcessNumbers = [NSMutableArray array];
    [GoalProcessNumbers addObject:goal.amount_DONE];
    [GoalProcessNumbers addObject:[NSNumber numberWithInt:([goal.amount intValue] - [goal.amount_DONE intValue] )]];
    
    int goalStatus = [self checkProcess:goal];
    switch (goalStatus) {
        case 1:
            cell.pieView.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:250/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
            cell.doneAmount.textColor = [UIColor colorWithRed:250/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f];
            break;
        case 2:
            cell.pieView.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:255/255.0f green:200/255.0f blue:100/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
            cell.doneAmount.textColor = [UIColor colorWithRed:255/255.0f green:200/255.0f blue:100/255.0f alpha:1.0f];
            
            break;
        case 3:
            cell.pieView.colorArray = [NSMutableArray arrayWithArray: @[[UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f],[UIColor colorWithRed:199/255.0f green:199/255.0f blue:199/255.0f alpha:1.0f]]];
            cell.doneAmount.textColor = [UIColor colorWithRed:5/255.0f green:190/255.0f blue:155/255.0f alpha:1.0f];
            
            break;
            
        default:
            break;
    }
    
    cell.pieView.sliceValues = GoalProcessNumbers;//must set sliceValue at the last step..

    
    
    return cell;
    

    
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"放弃"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}
- (NSArray *)twoRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"恢复"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}
- (NSArray *)oneRightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor clearColor]
                                                title:@""];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                title:@"+"];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                title:@"-"];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"cross.png"]];
//    [leftUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
//                                                icon:[UIImage imageNamed:@"list.png"]];
    
    return leftUtilityButtons;
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(MyCustomTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    GoalObj *goal = self.processingTasks[cellIndexPath.row];

    switch (index) {
        case 0:
            NSLog(@"+ was pressed");
            
            goal.amount_DONE = [NSNumber numberWithInt:([goal.amount_DONE intValue] + 1)];
            [cell.doneAmount setText:[NSString stringWithFormat:@"%@",goal.amount_DONE]];
            [self updateDataForTable:@"GOALSINFO" setColomn:@"amount_DONE" toData:goal.amount_DONE whereColomn:@"goalID" isData:goal.goalID];
            

            [cell hideUtilityButtonsAnimated:YES];
            if ([goal.amount_DONE intValue]==[goal.amount intValue]) {
                [self updateDataForTable:@"GOALSINFO" setColomn:@"isFinished" toData:[NSNumber numberWithInt:1] whereColomn:@"goalID" isData:goal.goalID];
                UIAlertView *fullAlert = [[UIAlertView alloc] initWithTitle:@"恭喜" message:@"您已成功完成目标，该目标将自动移入已完成列表。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                fullAlert.tag = 0;
                [fullAlert show];
          
            }

            

            break;
        case 1:
            NSLog(@"- was pressed");
            if ([goal.amount_DONE intValue] > 0) {

                goal.amount_DONE = [NSNumber numberWithInt:([goal.amount_DONE intValue] - 1)];
                [cell.doneAmount setText:[NSString stringWithFormat:@"%@",goal.amount_DONE]];
                [self updateDataForTable:@"GOALSINFO" setColomn:@"amount_DONE" toData:goal.amount_DONE whereColomn:@"goalID" isData:goal.goalID];
            }
            [cell hideUtilityButtonsAnimated:YES];
            
    

            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set last update time.
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];
    NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
    NSString *timeconvert = [NSString stringWithFormat:@"'%@'",timeNow];

    [self updateDataForTable:@"GOALSINFO" setColomn:@"lastUpdateTime" toData:timeconvert whereColomn:@"goalID" isData:goal.goalID];
    [self configProcessingTasks];
    
    if ([goal.amount_DONE intValue]<[goal.amount intValue]) {

    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:cellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }


}

- (void)swipeableTableViewCell:(MyCustomTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    
    switch (index) {
        case 0:
        {
            
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            

            
            if (self.goalTypeSegment.selectedSegmentIndex == 0) {
                NSLog(@"giveup button was pressed");
                
                UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"确认放弃该目标?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
                deleteAlert.tag = 2;
                [deleteAlert show];
                
                self.giveupCellIndexPath = cellIndexPath;
                
                [cell hideUtilityButtonsAnimated:YES];

                
            }else if(self.goalTypeSegment.selectedSegmentIndex == 1)
            {
                NSLog(@"clear button was pressed");

            }else if(self.goalTypeSegment.selectedSegmentIndex == 2)
            {
                NSLog(@"clear button was pressed");

            }else if(self.goalTypeSegment.selectedSegmentIndex == 3)
            {
                NSLog(@"recover button was pressed");
                
                UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"确认重拾该目标?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                deleteAlert.tag = 3;
                [deleteAlert show];
                
                self.recoverCellIndexPath = cellIndexPath;
                
                [cell hideUtilityButtonsAnimated:YES];
                

            }
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];


            UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"确认删除该项?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            deleteAlert.tag = 1;
            [deleteAlert show];
            
            self.deletingCellIndexPath = cellIndexPath;
            
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Segment changed

- (IBAction)goalTypeChanged:(id)sender {
    
    switch ([sender selectedSegmentIndex]) {
    
            case 0:
            NSLog(@"segment 0");
            [self configProcessingTasks];

            break;
            
            case 1:
            NSLog(@"segment 1");
            [self configFinishedTasks];
            break;
            
            case 2:
            NSLog(@"segment 2");
            [self configNotyetTasks];
            break;
            
            case 3:
            NSLog(@"segment 3");
            [self configGiveupTasks];
            break;
            
    }
    
    [self.tableView reloadData];
    
}
#pragma mark ADD NewGoal
- (IBAction)addNewGoal:(id)sender {
    
    addGoalViewController *addNewGoal = [[addGoalViewController alloc] initWithNibName:@"addGoalViewController" bundle:nil];
    

    addNewGoal.isNewGoal = TRUE;
    
    [self setupTransitioningDelegate];

    [self.navigationController pushViewController:addNewGoal animated:YES];


    
}
-(void)setupTransitioningDelegate{
    
    
    // Set up our delegate
    self.atcTD = [[ATCTransitioningDelegate alloc] initWithPresentationTransition:ATCTransitionAnimationTypeBounce
                                                                                 dismissalTransition:ATCTransitionAnimationTypeFloat
                                                                                           direction:ATCTransitionAnimationDirectionBottom
                                                                         duration:0.55f];
    self.navigationController.delegate = self.atcTD;

    
}

#pragma mark alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 0){ //move to finish list
        if (buttonIndex == 0) {
            [self configProcessingTasks];
            [self.tableView reloadData];
        }
    }else if(alertView.tag == 1) //be sure to delete
    {
        if (buttonIndex == 1) {
            
            if (self.goalTypeSegment.selectedSegmentIndex == 0) {
                
                GoalObj *goal = self.processingTasks[self.deletingCellIndexPath.row];
                [self deleteDataForTable:@"GOALSINFO" whereColomn:@"goalID" isData:goal.goalID];

    
                [self.processingTasks removeObjectAtIndex:self.deletingCellIndexPath.row];
                
            }else if(self.goalTypeSegment.selectedSegmentIndex == 1)
            {
                GoalObj *goal = self.finishedTasks[self.deletingCellIndexPath.row];
                [self deleteDataForTable:@"GOALSINFO" whereColomn:@"goalID" isData:goal.goalID];
                
                
                [self.finishedTasks removeObjectAtIndex:self.deletingCellIndexPath.row];
            }else if(self.goalTypeSegment.selectedSegmentIndex == 2)
            {
                GoalObj *goal = self.notyetTasks[self.deletingCellIndexPath.row];
                [self deleteDataForTable:@"GOALSINFO" whereColomn:@"goalID" isData:goal.goalID];
                
                
                [self.notyetTasks removeObjectAtIndex:self.deletingCellIndexPath.row];
            }else if(self.goalTypeSegment.selectedSegmentIndex == 3)
            {
                GoalObj *goal = self.giveupTasks[self.deletingCellIndexPath.row];
                [self deleteDataForTable:@"GOALSINFO" whereColomn:@"goalID" isData:goal.goalID];
                
                
                [self.giveupTasks removeObjectAtIndex:self.deletingCellIndexPath.row];
            }
            
            [self.tableView deleteRowsAtIndexPaths:@[self.deletingCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];


        }
    }else if(alertView.tag == 2)//be sure to give up
    {
        if (buttonIndex == 1) {
            
            
            GoalObj *goal = self.processingTasks[self.giveupCellIndexPath.row];
            
            [self updateDataForTable:@"GOALSINFO" setColomn:@"isGiveup" toData:[NSNumber numberWithInt:1] whereColomn:@"goalID" isData:goal.goalID];
            
            
            [self.processingTasks removeObjectAtIndex:self.giveupCellIndexPath.row];
            
            
            [self.tableView deleteRowsAtIndexPaths:@[self.giveupCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
            NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
            [dateFormat setLocale:locale];
            NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
            NSString *timeconvert = [NSString stringWithFormat:@"'%@'",timeNow];
            
            [self updateDataForTable:@"GOALSINFO" setColomn:@"lastUpdateTime" toData:timeconvert whereColomn:@"goalID" isData:goal.goalID];

            
            
        }
    }else if(alertView.tag == 3)//be sure to recover
    {
        if (buttonIndex == 1) {
            
            
            GoalObj *goal = self.giveupTasks[self.recoverCellIndexPath.row];
            
            [self updateDataForTable:@"GOALSINFO" setColomn:@"isGiveup" toData:[NSNumber numberWithInt:0] whereColomn:@"goalID" isData:goal.goalID];
            
            
            [self.giveupTasks removeObjectAtIndex:self.giveupCellIndexPath.row];
            
            
            [self.tableView deleteRowsAtIndexPaths:@[self.giveupCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
            NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
            [dateFormat setLocale:locale];
            NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
            NSString *timeconvert = [NSString stringWithFormat:@"'%@'",timeNow];
            
            [self updateDataForTable:@"GOALSINFO" setColomn:@"lastUpdateTime" toData:timeconvert whereColomn:@"goalID" isData:goal.goalID];
        }
    }
}
@end
