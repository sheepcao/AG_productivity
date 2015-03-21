//
//  settingViewController.m
//  AnyGoals
//
//  Created by Eric Cao on 3/21/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "settingViewController.h"

#define REVIEW_URL @"itms://itunes.apple.com/us/app/anygoal/id978629670?ls=1&mt=8"

#define ALLAPP_URL @"itms://itunes.com/apps/caoguangxu"

@interface settingViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *settingItems;
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.settingItems = [NSArray arrayWithObjects:@"教程",@"音效",@"评论",@"团队作品", nil];
    
    
}


#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.settingItems.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell_1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell_1)
    {
        cell_1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row == 1) {
        
        cell_1.textLabel.text = self.settingItems[indexPath.row];
        
        cell_1.backgroundColor = [UIColor clearColor];
        
        cell_1.detailTextLabel.font = [UIFont systemFontOfSize:30.0];
        cell_1.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:52/255.0f alpha:1.0f];
        [cell_1 setAccessoryType:UITableViewCellAccessoryNone];
        cell_1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UISwitch *soundSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(tableView.frame.size.width-70, 18, 60, 30)];
        [cell_1 addSubview:soundSwitch];
        [soundSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

        
    }else
    {
        
        cell_1.textLabel.text = self.settingItems[indexPath.row];
        
        cell_1.backgroundColor = [UIColor clearColor];
        
        cell_1.detailTextLabel.font = [UIFont systemFontOfSize:30.0];
        cell_1.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0f green:122/255.0f blue:52/255.0f alpha:1.0f];
        [cell_1 setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    }
    


    return cell_1;


}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self showScrollView];
            break;
        case 1:
            
            break;
        case 2:
        
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:REVIEW_URL]];

            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ALLAPP_URL]];

            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark switch action
-(void)switchAction:(UISwitch *)sender
{
    if (sender.isOn) {
        NSLog(@"sound on");
    }else
    {
        NSLog(@"sound off");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
}




- (IBAction)backToMain:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
