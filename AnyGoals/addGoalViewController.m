//
//  addGoalViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/12/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "addGoalViewController.h"
#import "ATCTransitioningDelegate.h"
#import "CustomDatePickerActionSheet.h"

@interface addGoalViewController ()<UITextFieldDelegate,UITextViewDelegate,DatePickerActionSheetDelegate>
@property (nonatomic,strong) ATCTransitioningDelegate *atcTD;
@property (nonatomic,strong) UIDatePicker *remindTimePicker;
@property (nonatomic,strong) UITextView *reminderNote;
@property (nonatomic,strong) UISwitch *reminderSwitch;

@property (nonatomic,strong) UILabel * timeSelected;
@property (nonatomic,strong) CustomDatePickerActionSheet *custom;
@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,strong) NSString *reminderTime;
@end

@implementation addGoalViewController

@synthesize goalNameField;
@synthesize actionTimesField;
@synthesize startTimeField;
@synthesize endTimeField;
@synthesize textfieldArray;
@synthesize remindTimePicker;
@synthesize timeSelected;
@synthesize custom;
@synthesize db;
@synthesize reminderTime;
@synthesize reminderNote;
@synthesize reminderSwitch;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    goalNameField = [[UITextField alloc] init];
    actionTimesField = [[UITextField alloc] init];
    startTimeField = [[UIButton alloc] init];
    endTimeField = [[UIButton alloc] init];

    
    textfieldArray = [[NSMutableArray alloc] initWithObjects:goalNameField,actionTimesField,startTimeField,endTimeField, nil];
    custom = [[CustomDatePickerActionSheet alloc] initWithDelegate:self];



    [self setupUI];
}


-(void)setupUI
{
    
    //init position of bar buttons
    [self.pageTitle setFrame:CGRectMake(SCREEN_WIDTH-130/2, 30, 130, 40)];
    [self.backBtn setFrame:CGRectMake(20, self.pageTitle.frame.origin.y, 45, 35)];
    [self.saveBtn setFrame:CGRectMake(SCREEN_WIDTH-20-45, self.pageTitle.frame.origin.y, 45, 35)];
    

    self.goalInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.pageTitle.frame.origin.y+50, SCREEN_WIDTH, SCREEN_HEIGHT-(self.pageTitle.frame.origin.y+50))];
    if (IS_IPHONE_4_OR_LESS) {
        self.goalInfoScrollView.contentSize = CGSizeMake(self.goalInfoScrollView.frame.size.width, self.goalInfoScrollView.frame.size.height+100);

    }else
    {
        self.goalInfoScrollView.contentSize = CGSizeMake(self.goalInfoScrollView.frame.size.width, self.goalInfoScrollView.frame.size.height);

    }
    self.goalInfoScrollView.showsVerticalScrollIndicator = NO;
    self.goalInfoScrollView.showsHorizontalScrollIndicator = NO;

    
    [self.view addSubview:self.goalInfoScrollView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.goalInfoScrollView addGestureRecognizer:tap];
    
    for (int i = 0; i <2; i++) {
     
        UIImageView *editingImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 30 + 50*i, 35, 35)];
        [editingImage setImage:[UIImage imageNamed:@"skip"]];
        [self.goalInfoScrollView addSubview:editingImage];
        
        UITextField *txtfield = self.textfieldArray[i];
        
        [txtfield setFrame:CGRectMake(45, 30 + 50*i, SCREEN_WIDTH-45-45, 35)];
        
        txtfield.borderStyle = UITextBorderStyleNone;
        txtfield.delegate=self;
        [self.goalInfoScrollView addSubview:txtfield];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, txtfield.frame.origin.y+txtfield.frame.size.height+1, SCREEN_WIDTH-45-5, 0.7)];
        [line setBackgroundColor:[UIColor grayColor]];
        [self.goalInfoScrollView addSubview:line];
        
    }
    [goalNameField setReturnKeyType:UIReturnKeyDone];

    actionTimesField.keyboardType = UIKeyboardTypeNumberPad;
    for (int i = 2; i <4; i++) {
        
        UIImageView *editingImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-45, 30 + 50*i, 35, 35)];
        [editingImage setImage:[UIImage imageNamed:@"skip"]];
        [self.goalInfoScrollView addSubview:editingImage];
        
        UIButton *timeBtn = self.textfieldArray[i];
        
        [timeBtn setFrame:CGRectMake(45, 30 + 50*i, SCREEN_WIDTH-45-45, 35)];
        
        timeBtn.layer.borderWidth = 0;
        timeBtn.tag = i;
        [timeBtn addTarget:self action:@selector(timeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.goalInfoScrollView addSubview:timeBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, timeBtn.frame.origin.y+timeBtn.frame.size.height+1, SCREEN_WIDTH-45-5, 0.7)];
        [line setBackgroundColor:[UIColor grayColor]];
        [self.goalInfoScrollView addSubview:line];
        
    }

    goalNameField.textAlignment = NSTextAlignmentCenter;
    actionTimesField.textAlignment = NSTextAlignmentCenter;
    [startTimeField setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [endTimeField setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    startTimeField.titleLabel.textAlignment = NSTextAlignmentLeft;


    UILabel *reminder = [[UILabel alloc] initWithFrame:CGRectMake(50, endTimeField.frame.origin.y+endTimeField.frame.size.height+30, 200, 35)];
    reminder.textAlignment = NSTextAlignmentLeft;
    reminder.text = @"\t提醒我";
    reminder.textColor = [UIColor lightGrayColor];
    
    reminderSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, reminder.frame.origin.y+1, 51, 31)];
    [reminderSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, reminder.frame.origin.y+reminder.frame.size.height+1, SCREEN_WIDTH-45-5, 0.7)];
    [line setBackgroundColor:[UIColor grayColor]];
    [self.goalInfoScrollView addSubview:line];
    [self.goalInfoScrollView addSubview:reminderSwitch];
    [self.goalInfoScrollView addSubview:reminder];



    
    
    remindTimePicker = [[UIDatePicker alloc] init];
    timeSelected = [[UILabel alloc] init];
    
    reminderNote = [[UITextView alloc] init];
    reminderNote.delegate = self;
    reminderNote.font = [UIFont systemFontOfSize:17.0f];

    
    
    if (self.isNewGoal) {

    }else
    {
        //to do select from db...
    }

    [remindTimePicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
    
    if(self.isNewGoal)
    {
        goalNameField.placeholder = @"目标名称";
        actionTimesField.placeholder = @"行动次数";
        
        [startTimeField setTitle:@"开始时间" forState:UIControlStateNormal];
        [endTimeField setTitle:@"截至时间" forState:UIControlStateNormal];
        
        reminderTime = @"";
        [reminderNote setText:@"点击编辑提醒备注..."];
        [reminderNote setTextColor:[UIColor lightGrayColor]];
        
    }else
    {
        if (self.editingGoal) {
            [goalNameField setText:self.editingGoal.goalName];
            [actionTimesField setText:[NSString stringWithFormat:@"%d",[self.editingGoal.amount intValue]]];
            [startTimeField setTitle:self.editingGoal.startTime forState:UIControlStateNormal];
            [endTimeField setTitle:self.editingGoal.endTime forState:UIControlStateNormal];
            if (![self.editingGoal.reminder isEqualToString:@""]) {
                
                [reminderSwitch setOn:YES];
                [self switchAction:reminderSwitch];
                
            }
            
            reminderTime = self.editingGoal.reminder;

            [reminderNote setText:self.editingGoal.reminderNote];
            if ([self.editingGoal.reminderNote isEqualToString:@"点击编辑提醒备注..."]) {
                [reminderNote setTextColor:[UIColor lightGrayColor]];

            }else
            {
                [reminderNote setTextColor:[UIColor blackColor]];

            }
            
            
        }
        
        
    }
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
}

#pragma mark switch action
-(void)switchAction:(id)sender
{
    [self.view endEditing:YES];
    [custom close];
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        
        [remindTimePicker setFrame:CGRectMake(45, switchButton.frame.origin.y+45, SCREEN_WIDTH-90, (SCREEN_WIDTH-10)*0.46)];
        remindTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
        
        timeSelected = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 150, remindTimePicker.frame.origin.y+remindTimePicker.frame.size.height, 300, 30)];
        timeSelected.textAlignment = NSTextAlignmentCenter ;
        
        [reminderNote setFrame:CGRectMake(45, timeSelected.frame.origin.y+timeSelected.frame.size.height+2, remindTimePicker.frame.size.width, remindTimePicker.frame.size.height/2)];

        
        //to do .. select reminder time in db and show.include setting date picker.
        if (self.isNewGoal || [reminderTime isEqualToString:@""]) {
            reminderTime = @"未选择";
            [timeSelected setText:[NSString stringWithFormat:@"已选时间: %@",reminderTime]];
        }else
        {
            reminderTime = self.editingGoal.reminder;
            [timeSelected setText:[NSString stringWithFormat:@"已选时间: %@",reminderTime]];
            
            NSDateFormatter *reminderDateFormatter = [[NSDateFormatter alloc] init];
            reminderDateFormatter.dateFormat = @"yyyy/MM/dd HH:mm"; // 设置时间和日期的格式
            
            NSDate *remindDate =[reminderDateFormatter dateFromString:reminderTime];
            
            [remindTimePicker setDate:remindDate animated:YES];
            
            
        }
        
        
        if (!remindTimePicker.superview) {
            [self.goalInfoScrollView addSubview:remindTimePicker];
            [self.goalInfoScrollView addSubview:timeSelected];
            [self.goalInfoScrollView addSubview:reminderNote];
        }

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 145)];

        [UIView commitAnimations];
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+145)];
        if (IS_IPHONE_4_OR_LESS) {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+200)];
            [self.goalInfoScrollView setContentOffset:CGPointMake(0, 185)];


        }else
        {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+145)];

        }
        
    }else {
        if (remindTimePicker.superview) {
            [remindTimePicker removeFromSuperview];
            [timeSelected removeFromSuperview];
            [reminderNote removeFromSuperview];
        }
        if (![reminderTime isEqualToString:@""]) {
            reminderTime = @"";
        }
        [UIView beginAnimations:nil context:NULL];

        [UIView setAnimationDuration:0.35f];

        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 0)];
        [UIView commitAnimations];

        if (IS_IPHONE_4_OR_LESS) {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+100)];
            
        }else
        {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height)];
        }
    }
}
#pragma mark - 实现oneDatePicker的监听方法
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    
    NSDate *select = [remindTimePicker date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy/MM/dd HH:mm"; // 设置时间和日期的格式
    
    reminderTime =[selectDateFormatter stringFromDate:select];
    
    NSString *dateAndTime =[NSString stringWithFormat:@"已选时间:%@",reminderTime] ;
    
    [timeSelected setText:dateAndTime];
    
    NSLog(@"date:%@",dateAndTime);
    // 在控制台打印消息
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)timeSelect:(UIButton *)sender
{
    
    //eric: custom action sheet.
    
    [goalNameField resignFirstResponder];
    [actionTimesField resignFirstResponder];
    
    [custom setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
    [self.view addSubview:custom];
    custom.tag = sender.tag;
    [custom showInView];

}
- (void)dateChanged:(CustomDatePickerActionSheet *)datePickerActionSheet {
    NSLog(@"date %@", datePickerActionSheet.date.debugDescription);
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];

    
    if (datePickerActionSheet.tag == 2) {
        [startTimeField setTitle:[dateFormat stringFromDate:[datePickerActionSheet date]] forState:UIControlStateNormal];
    }else
    {
        [endTimeField setTitle:[dateFormat stringFromDate:[datePickerActionSheet date]] forState:UIControlStateNormal];

    }
}


-(BOOL)checkTimeValidation
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *start = [dateFormat dateFromString:startTimeField.titleLabel.text];
    NSDate *end = [dateFormat dateFromString:endTimeField.titleLabel.text];
    
    if ([start compare:end] == NSOrderedAscending)
    {
        return true;
    }else
    {
        UIAlertView *reminderError = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"目标开始时间应设置在截至时间之后!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [reminderError show];
        return false;
    }


    
}


-(BOOL)checkReminderValidation
{
    if (![reminderTime isEqualToString:@""]) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSDate *reminder = [dateFormat dateFromString:reminderTime];
        
        if ([reminder compare:[NSDate date]] == NSOrderedDescending)
        {
            return TRUE;
        }else
        {
            UIAlertView *reminderError = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"提醒时间应为未来的某一时刻!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [reminderError show];
            return false;

        }

    }else
    {
        return TRUE;
    }

    
    
}
-(BOOL)checkInfoValidation
{

    if (goalNameField.text.length>0 && actionTimesField.text.length>0 && ![startTimeField.titleLabel.text isEqualToString:@"开始时间"] && ![endTimeField.titleLabel.text isEqualToString:@"截至时间"]) {
        return TRUE;
    }
    UIAlertView *reminderError = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"请完整设置目标基本信息!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [reminderError show];
    return false;
}
- (IBAction)saveGoal:(id)sender {

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    //set locale
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray* arrayLanguages = [userDefaults objectForKey:@"AppleLanguages"];
    NSString* currentLanguage = [arrayLanguages objectAtIndex:0];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currentLanguage];
    [dateFormat setLocale:locale];
    NSString *timeNow = [dateFormat stringFromDate:[NSDate date]];
    
    if ([self checkReminderValidation] && [self checkInfoValidation] && [self checkTimeValidation]) {
        
        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docsPath stringByAppendingPathComponent:@"AnyGoals.db"];
        NSString *remindNote = @"点击编辑提醒备注...";
        
        if (reminderNote.superview) {
            remindNote = reminderNote.text;
        }
        
        db = [FMDatabase databaseWithPath:dbPath];
        
        if (![db open]) {
            NSLog(@"Could not open db.");
            return;
        }
        if(self.isNewGoal)
        {
            BOOL sql = [db executeUpdate:@"insert into GOALSINFO (goalName, startTime,endTime,amount,amount_DONE,lastUpdateTime,reminder,reminderNote,isFinished,isGiveup) values (?,?,?,?,?,?,?,?,?,?)" , goalNameField.text, startTimeField.titleLabel.text,endTimeField.titleLabel.text,[NSNumber numberWithInt:[actionTimesField.text intValue]],[NSNumber numberWithInt:0],timeNow,reminderTime,remindNote,[NSNumber numberWithInt:0],[NSNumber numberWithInt:0]];
            
            if (!sql) {
                NSLog(@"ERROR: %d - %@", db.lastErrorCode, db.lastErrorMessage);
            }
            [db close];
        }else
        {

            
           BOOL sql = [db executeUpdate:@"update GOALSINFO set goalName = ?, startTime= ?,endTime =?,amount=?,lastUpdateTime=?,reminder=?,reminderNote=?,isFinished=?,isGiveup=? where goalID = ?" , goalNameField.text, startTimeField.titleLabel.text,endTimeField.titleLabel.text,[NSNumber numberWithInt:[actionTimesField.text intValue]],timeNow,reminderTime,remindNote,[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],self.editingGoal.goalID];
            if (!sql) {
                NSLog(@"ERROR: %d - %@", db.lastErrorCode, db.lastErrorMessage);
            }
            [db close];
        }
        
        [self.navigationController popViewControllerAnimated:YES];


    }

   
}

- (IBAction)backHome:(id)sender {
//    [self setupTransitioningDelegate];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupTransitioningDelegate{
    
    
    // Set up our delegate
    self.atcTD = [[ATCTransitioningDelegate alloc] initWithPresentationTransition:ATCTransitionAnimationTypeBounce
                                                              dismissalTransition:ATCTransitionAnimationTypeBounce
                                                                        direction:ATCTransitionAnimationDirectionBottom
                                                                         duration:0.65f];
    self.navigationController.delegate = self.atcTD;
    
    
}

#pragma mark textfiled delegate
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [goalNameField resignFirstResponder];
    [actionTimesField resignFirstResponder];


}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [custom close];
    return YES;
}// return NO to disallow editing.


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
-(void)dismissKeyboard {
    

    [goalNameField resignFirstResponder];
    [actionTimesField resignFirstResponder];
    if ([reminderNote isFirstResponder]) {
        [reminderNote resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35f];
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 145)];
        
        [UIView commitAnimations];
        if (IS_IPHONE_4_OR_LESS) {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+200)];

        }else
        {
            [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+145)];

        }

    }
    
}
#pragma mark textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{

    if ([textView.text isEqualToString:@"点击编辑提醒备注..."]) {
        textView.text = @"";

    }
    textView.textColor = [UIColor blackColor];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35f];
    if(IS_IPHONE_4_OR_LESS)
    {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+390)];

        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 390)];

    }else if (IS_IPHONE_5)
    {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+330)];
        
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 330)];
    }else if (IS_IPHONE_6)
    {
    [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+250)];

    [self.goalInfoScrollView setContentOffset:CGPointMake(0, 250)];
    }else
    {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+240)];
        
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 240)];
    }
    [UIView commitAnimations];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        [textView setText:@"点击编辑提醒备注..."];
        [textView setTextColor:[UIColor lightGrayColor]];
    }


    if (IS_IPHONE_4_OR_LESS) {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+200)];
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 200)];
        
        
    }else
    {
        [self.goalInfoScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, self.goalInfoScrollView.frame.size.height+145)];
        [self.goalInfoScrollView setContentOffset:CGPointMake(0, 145)];

        
    }
    
}


@end
