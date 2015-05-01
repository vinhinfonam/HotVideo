//
//  AVPlayerView.h
//  TelenorMyTV
//
//  Created by Vinh Nguyen on 3/6/15.
//  Copyright (c) 2015 UUX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;

@interface AVPlayerView : UIView

@property (nonatomic, strong) AVPlayer* player;

- (void)setAVPlayer:(AVPlayer*)player;

@end
