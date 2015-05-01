//
//  NavigationViewController.h

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerView.h"

@interface NavigationViewController : UINavigationController

@property(strong, nonatomic) PlayerView *playerView;

- (void)showMenu;
- (void) addPlayer;

@end
