//
//  MiniPlayerGesture.h
//  TelenorMyTV

#import <Foundation/Foundation.h>
#import "PlayerView.h"

@interface PlayerGestureRegconize : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) PlayerView *playerView;

+ (instancetype)sharedInstance;
- (void)addPanGestureForPlayerView:(PlayerView *)playerView;
- (void)addPinGestureForPlayerView:(PlayerView *)playerView;
- (void)removeGesture;
@end
