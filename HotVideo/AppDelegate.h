//
//  AppDelegate.h
//  HotVideo
//
//  Created by Vinh Nguyen on 3/28/15.
//  Copyright (c) 2015 Vinh Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "NavigationViewController.h"
#import "PlayerView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, REFrostedViewControllerDelegate>{
    REFrostedViewController __strong *frostedViewController;
    NavigationViewController *_navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property(strong, nonatomic) REFrostedViewController *frostedViewController;
@property(strong, nonatomic) NavigationViewController *navigationController;
@property (strong, nonatomic) PlayerView *videoPlayer;


@end

