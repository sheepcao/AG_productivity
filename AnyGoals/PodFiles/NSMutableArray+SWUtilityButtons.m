//
//  NSMutableArray+SWUtilityButtons.m
//  SWTableViewCell
//
//  Created by Matt Bowman on 11/27/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import "NSMutableArray+SWUtilityButtons.h"

@implementation NSMutableArray (SWUtilityButtons)

- (BOOL)isSystemLangChinese
{
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    
    if([language compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        return YES;
    }else
    {
        return NO;
    }
}
- (void)sw_addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];

    [self addObject:button];
}
- (void)sw_addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title body:(NSString *)body
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, 80, 30)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];

    
    UILabel *bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 90, 70)];
    bodyLabel.text = body;
    bodyLabel.numberOfLines = 2;
    bodyLabel.textAlignment = NSTextAlignmentCenter;
    bodyLabel.textColor = [UIColor whiteColor];
    
    [self addObject:button];
    if ([self isSystemLangChinese]) {

        [titleLabel setFrame:CGRectMake(25, 37, 50, 30)];
        titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        [bodyLabel setFrame:CGRectMake(10, 65, 80, 40)];
        bodyLabel.font = [UIFont systemFontOfSize:12.0f];

    }else
    {
        titleLabel.font = [UIFont boldSystemFontOfSize:21.0f];
        bodyLabel.font = [UIFont systemFontOfSize:12.0f];
        bodyLabel.numberOfLines = 4;

        
    }

    [button addSubview:titleLabel];
    [button addSubview:bodyLabel];
}

- (void)sw_addUtilityButtonWithColor:(UIColor *)color attributedTitle:(NSAttributedString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setAttributedTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addObject:button];
}

- (void)sw_addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    UIImageView *image = [[UIImageView alloc] initWithImage:icon];

    [button addSubview:image];
    [image setFrame:CGRectMake(25, 40, 50, 50)];
    [image setBackgroundColor:[UIColor clearColor]];
//    [button setImage:icon forState:UIControlStateNormal];
    [self addObject:button];
}

- (void)sw_addUtilityButtonWithColor:(UIColor *)color normalIcon:(UIImage *)normalIcon selectedIcon:(UIImage *)selectedIcon {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setImage:normalIcon forState:UIControlStateNormal];
    [button setImage:selectedIcon forState:UIControlStateHighlighted];
    [button setImage:selectedIcon forState:UIControlStateSelected];
    [self addObject:button];
}

@end


@implementation NSArray (SWUtilityButtons)

- (BOOL)sw_isEqualToButtons:(NSArray *)buttons
{
    buttons = [buttons copy];
    if (!buttons || self.count != buttons.count) return NO;
    
    for (NSUInteger idx = 0; idx < self.count; idx++) {
        id buttonA = self[idx];
        id buttonB = buttons[idx];
        if (![buttonA isKindOfClass:[UIButton class]] || ![buttonB isKindOfClass:[UIButton class]]) return NO;
        if (![[self class] sw_button:buttonA isEqualToButton:buttonB]) return NO;
    }
    
    return YES;
}

+ (BOOL)sw_button:(UIButton *)buttonA isEqualToButton:(UIButton *)buttonB
{
    if (!buttonA || !buttonB) return NO;
    
    UIColor *backgroundColorA = buttonA.backgroundColor;
    UIColor *backgroundColorB = buttonB.backgroundColor;
    BOOL haveEqualBackgroundColors = (!backgroundColorA && !backgroundColorB) || [backgroundColorA isEqual:backgroundColorB];
    
    NSString *titleA = [buttonA titleForState:UIControlStateNormal];
    NSString *titleB = [buttonB titleForState:UIControlStateNormal];
    BOOL haveEqualTitles = (!titleA && !titleB) || [titleA isEqualToString:titleB];
    
    UIImage *normalIconA = [buttonA imageForState:UIControlStateNormal];
    UIImage *normalIconB = [buttonB imageForState:UIControlStateNormal];
    BOOL haveEqualNormalIcons = (!normalIconA && !normalIconB) || [normalIconA isEqual:normalIconB];
    
    UIImage *selectedIconA = [buttonA imageForState:UIControlStateSelected];
    UIImage *selectedIconB = [buttonB imageForState:UIControlStateSelected];
    BOOL haveEqualSelectedIcons = (!selectedIconA && !selectedIconB) || [selectedIconA isEqual:selectedIconB];
    
    return haveEqualBackgroundColors && haveEqualTitles && haveEqualNormalIcons && haveEqualSelectedIcons;
}

@end
