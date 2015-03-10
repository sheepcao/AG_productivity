//
//  FirstViewController.h
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalVar.h"
#import "SWTableViewCell.h"

@interface FirstViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>


@property (nonatomic,strong) NSMutableArray *processingTasks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

