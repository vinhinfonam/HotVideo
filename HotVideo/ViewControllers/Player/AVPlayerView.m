//
//  AVPlayerView.m
//  TelenorMyTV
//
//  Created by Vinh Nguyen on 3/6/15.
//  Copyright (c) 2015 UUX. All rights reserved.
//

#import "AVPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@implementation AVPlayerView

+ (Class)layerClass{
    return [AVPlayerLayer class];
}

- (AVPlayer*)player{
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setAVPlayer:(AVPlayer*)player{
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}

@end
