//
//  FirstViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "FirstViewController.h"
#import "MyCustomTableViewCell.h"

@interface FirstViewController ()<UIScrollViewDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self configTasks];

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //判断滑动图是否出现过，第一次调用时“isScrollViewAppear” 这个key 对应的值是nil，会进入if中
    if (![@"YES" isEqualToString:[userDefaults objectForKey:@"isScrollViewAppear"]]) {
        
        [self showScrollView];//显示滑动图
    }else
    {
        [self.tabBarController.tabBar setHidden:NO];

    }
    
    
    
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

-(void)configTasks
{
    self.processingTasks = [NSMutableArray arrayWithArray:@[@"1",@"2",@"3",@"4",@"5"]];
}


#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.processingTasks count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"MyCustomCell";
    
    MyCustomTableViewCell *cell = (MyCustomTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                                           forIndexPath:indexPath];
    
    [cell setLeftUtilityButtons:[self leftButtons] WithButtonWidth:32.0f];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    cell.delegate = self;
    
    cell.GoalName.text = self.processingTasks[indexPath.row];
    
    NSMutableArray *randomNumbers = [NSMutableArray array];
    int count = 1 + rand() % 10;
    for (int i = 1; i < 3; i++) {
        //		[randomNumbers addObject:[NSNumber numberWithInt:rand() % 100]];
        [randomNumbers addObject:[NSNumber numberWithInt:10*i]];
    }
    cell.pieView.colorArray = [NSMutableArray arrayWithArray: @[[UIColor greenColor],[UIColor lightGrayColor]]];
    cell.pieView.sliceValues = randomNumbers;//must set sliceValue at the last step..
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
                                                icon:[UIImage imageNamed:@"check.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
                                                icon:[UIImage imageNamed:@"clock.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
                                                icon:[UIImage imageNamed:@"cross.png"]];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
                                                icon:[UIImage imageNamed:@"list.png"]];
    
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

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.processingTasks[cellIndexPath.row] removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
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

@end
