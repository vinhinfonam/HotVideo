//
//  LeftmenuViewController.h
//  HightLearning
//
//  Created by VinhNguyen on 7/15/14.
//  Copyright (c) 2014 Synova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"

@interface LeftmenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *arrMenu;
    UITableView *tblMenu;
}

@end
