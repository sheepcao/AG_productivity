//
//  MyCustomTableViewCell.h
//  AnyGoals
//
//  Created by Eric Cao on 3/10/15.
//  Copyright (c) 2015 Eric Cao. All rights reserved.
//

#import "SWTableViewCell.h"
#import "PieView.h"

@interface MyCustomTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *GoalName;
@property (weak, nonatomic) IBOutlet PieView *pieView;

@end
