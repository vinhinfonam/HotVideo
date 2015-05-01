//
//  HeaderView.m
//  HotVideo
//
//  Created by Vinh Nguyen on 4/18/15.
//  Copyright (c) 2015 Vinh Nguyen. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 44)];
   
}

- (void) layoutSubviews{
    self.frame = CGRectMake(0, 20, kScreenSize.width, 44);
    self.backgroundColor = [UIColor blueColor];
}


@end
