//
//  PlayerControl.m
//  TelenorMyTV
//
//  Created by Nguyen Tan Thanh on 2/10/15.
//  Copyright (c) 2015 UUX. All rights reserved.
//

#import "PlayerControl.h"
//#import <objc/message.h>

@implementation PlayerControl


+ (instancetype)createWithPlayerView:(PlayerView *)playerView {
    PlayerControl *playerControl = [[[NSBundle mainBundle] loadNibNamed:@"PlayerControl" owner:self options:nil] lastObject];
    playerControl.playerView = playerView;
    playerControl.frame = playerView.frame;
    
    [playerView addSubview:playerControl];
    [playerView bringSubviewToFront:playerControl];
    
    return playerControl;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.topControl setBackgroundColor:[UIColor clearColor]];
    [self.fullscreenTopControl setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
    [self.bottomControl setBackgroundColor:[UIColor clearColor]];
    [self.fullscreenBottomControl setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    [self.btnNextEpisode setTitleColor:[UIColor colorWithRed:1/255.0 green:143/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    
}

/**
 * Touch hide/show control in playerView
 */

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch1 = [touches anyObject];
    CGPoint touchLocation = [touch1 locationInView:self];
    
    /*
    if ( ! CGRectContainsPoint(self.channelList.frame, touchLocation) ) {
        
        //Hide side menu
        [self showOrHideControls:self.topControl.hidden ? YES : NO];
    }
     */
}

- (void)setUpVolumnBar {
    MPVolumeView *mpVolumeView = [[MPVolumeView alloc] initWithFrame: CGRectMake(self.frame.size.width-100-5, 11, 100, 31)];
    
    //=========== Custom thumb image for sliders ==============
    UIView  *volumeSliderView;
    for (UIView *view in [mpVolumeView subviews]) {
        if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) {
            volumeSliderView = view;
            break;
        }
    }
    
    UIImage *sliderTrackImage = [UIImage imageNamed: @"btn_volume_24x24"];
    
    if (nil != volumeSliderView) {
        [(UISlider *)volumeSliderView setThumbImage:sliderTrackImage forState:UIControlStateNormal];
    }
    [self.videoProgressBar setThumbImage:sliderTrackImage forState:UIControlStateNormal];
    
    //============== End ======================================
    
    mpVolumeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [self.fullscreenTopControl addSubview:mpVolumeView];
}

- (IBAction)btnCloseClicked:(UIButton *)sender {
    //TODO call PlayerView do exit
    //[[kApplicationDelegate mainNaviController] closeMiniPlayer];
}

- (IBAction)btnTVChannelsClicked:(UIButton *)sender {
    
//    self.playerView.lbLoading.text = @"";
//    [self.playerView showOrHideLoadingStatus:YES];
    //Hide tv channel list
    if (self.btnTVChannels.selected) {
        
        //TODO hide tv channel list
        
        self.btnTVChannels.selected = NO;
        self.btnTVChannelsArrow.selected = NO;
        
    }
    //Show tv channel list
    else {
        
         [self loadChannelList];
        
        //TODO show tv channel list
        
        self.btnTVChannels.selected = YES;
        self.btnTVChannelsArrow.selected = YES;
    }
}

- (IBAction)volumnBarValueChanged:(UISlider *)sender {
    //[[MPMusicPlayerController applicationMusicPlayer] setVolume:self.volumnBar.value];
}

- (IBAction)btnPlayPauseClicked:(UIButton *)sender {
    
    //To resume
    if (self.btnPlayPause.selected) {
        
        //TODO call PlayerView do pause
        
        [self.playerView resume];
//        self.btnPlayPause.selected = NO;
        [self showControlAtPauseStatus:YES];
    }
    //To pause
    else {
        
        //TODO call PlayerView do resume
        [self.playerView pause];
//        self.btnPlayPause.selected = YES;
        [self showControlAtPauseStatus:NO];
        
    }
}


- (IBAction)btnZoomClicked:(UIButton *)sender {
    self.forceToMiniMode = NO;
    
    //To mini mode
    if (self.btnZoom.selected) {
        
        //TODO call PlayerView enter to mini mode.
        self.btnZoom.selected = false;
        
        //hotfix when device is PORTRAIT and press zoom in button
        if ( UIInterfaceOrientationPortrait == [UIDevice currentDevice].orientation ) {
           // objc_msgSend([UIDevice currentDevice],@selector(setOrientation:), [UIApplication sharedApplication].statusBarOrientation);
        }
        
        [self performSelector:@selector(forceAppToMiniMode) withObject:nil afterDelay:0.1];
    }
    //To fullscreen mode
    else {
        //TODO call PlayerView enter to mini mode.
        self.btnZoom.selected = true;
        
        [Utils forceAppRotateToLandscape:YES];

    }
}

- (void)forceAppToMiniMode {
    self.forceToMiniMode = YES;
    [Utils forceAppRotateToLandscape:NO];
}

- (IBAction)videoProgressBarValueChanged:(UISlider *)sender {
    //TODO call PlayerView jump to selected value
    [self.playerView setMediaPosition:self.videoProgressBar.value];
    
}

- (IBAction)btnNextEpisode:(id)sender {
    [self.playerView requestNextEpisode];
}

- (IBAction)btnLanguageClicked:(id)sender {
    //show language list
}

- (void)showOrHideControls:(BOOL)willShow {
    if (willShow) {
        self.topControl.hidden = NO;
        self.bottomControl.hidden = NO;
        
        //PiP Screen
        if (self.playerView.pipAVPlayer) {
            self.playerView.pipView.hidden = NO;
            self.playerView.pipAVPlayerLayer.hidden = NO;
        }
    }
    else {
        self.topControl.hidden = YES;
       
        self.bottomControl.hidden = YES;
        
        //PiP Screen
        if (self.playerView.pipView) {
            self.playerView.pipView.hidden = YES;
            self.playerView.pipAVPlayerLayer.hidden = YES;
        }
    }
}

- (void)showControlInMiniMode {
    self.fullscreenTopControl.hidden = YES;
    self.fullscreenBottomControl.hidden = YES;
    self.videoProgressBar.hidden = YES;
    self.btnZoom.selected = NO;
    self.btnClose.hidden = NO;
    self.viewNextEpisode.hidden = YES;

}

- (void)showControlInFullscreenMode {
    self.fullscreenTopControl.hidden = NO;
    self.fullscreenBottomControl.hidden = NO;
    self.btnZoom.selected = YES;
    self.btnClose.hidden = YES;
    
    if (self.playerView.isEpisodes) {
        self.txtMovieTitle.text = self.episodeMovieTitle;
    } else {
        //self.txtMovieTitle.text = self.mediaUrl.programName;
    }
    
    if (self.isLiveStream) {
        self.btnTVChannels.hidden = NO;
        self.btnTVChannelsArrow.hidden = NO;
        self.videoProgressBar.hidden = YES;
        self.txtLiveTitle.hidden = NO;
        self.lblDuration.hidden = YES;
        self.lblPlaybackTime.hidden = YES;
        self.viewNextEpisode.hidden = YES;
        
        //self.txtMovieTitle.text = self.mediaUrl.programName;
        
        self.bgChannelView.frame = CGRectMake(156, 0, 34, 36);
        self.imgChannel.frame = CGRectMake(156, 4, 34, 32);
        if (!self.btnChromeCast.hidden) {
            self.txtMovieTitle.frame = CGRectMake(156 + self.imgChannel.frame.size.width + 10, 10, self.btnChromeCast.frame.origin.x - self.txtMovieTitle.frame.origin.x, 21);
        }
        else {
            self.txtMovieTitle.frame = CGRectMake(156 + self.imgChannel.frame.size.width + 10, 10, self.btnLanguage.frame.origin.x - self.txtMovieTitle.frame.origin.x, 21);
        }
    }
    else {
        
        //self.videoProgressBar.value = [self.playerView getMediaOffset];
        if (self.isCatchupTV) {
            self.bgChannelView.frame = CGRectMake(10, 0, 34, 36);
            self.imgChannel.frame = CGRectMake(10, 4, 34, 32);
            if (!self.btnChromeCast.hidden) {
                self.txtMovieTitle.frame = CGRectMake(10 + self.imgChannel.frame.size.width + 10, 10, self.btnChromeCast.frame.origin.x - self.txtMovieTitle.frame.origin.x, 21);
            }
            else {
                self.txtMovieTitle.frame = CGRectMake(10 + self.imgChannel.frame.size.width + 10, 10, self.btnLanguage.frame.origin.x - self.txtMovieTitle.frame.origin.x, 21);
            }
        }
        else {
            if (!self.btnChromeCast.hidden) {
                self.txtMovieTitle.frame = CGRectMake(10, 10, self.btnChromeCast.frame.origin.x - self.txtMovieTitle.frame.origin.x, 21);
            }
            else {
                self.txtMovieTitle.frame = CGRectMake(10, 10, self.btnChromeCast.frame.origin.x - self.txtMovieTitle.frame.origin.x, 21);
            }
        }
        
        self.txtMovieTitle.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.bgChannelView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.imgChannel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        self.videoProgressBar.hidden = NO;
        self.btnTVChannels.hidden = YES;
        self.btnTVChannelsArrow.hidden = YES;
        self.txtLiveTitle.hidden = YES;
        self.viewNextEpisode.hidden = NO;
        self.lblDuration.hidden = NO;
                
    }
}

- (void)setVideoDuration:(int)duration {
    //self.lblDuration.text = [PlayerHelper formatTimeLabel:duration];
}

- (void)showPlaybackTime:(int)currentTime {
    
//    if (currentTime > 0) {
//        self.lblPlaybackTime.text = [NSString stringWithFormat:@"%@ / ", [PlayerHelper formatTimeLabel:currentTime]];
//    }
}

- (void)resetControl {
   
    self.btnTVChannels.selected = NO;
    self.btnTVChannelsArrow.selected = NO;
    self.btnPlayPause.selected = NO;
    
}

/**
 * This method will be called from video player status callback
 */
- (void)updateVideoProgressBar:(float)value {
    self.videoProgressBar.value = value;    
}

#pragma mark - Show Next Episode Info

- (void)showNextButton:(BOOL)isShow{
    self.btnNextEpisode.hidden = !isShow;
    self.lblNextEpisode.hidden =!isShow;
}

- (void)showNextEpisodeInfo:(NSString *) info{
    
    self.viewNextEpisode.hidden = info.length > 0?NO:YES;
    self.lblNextEpisode.hidden = info.length > 0?NO:YES;
    self.lblNextEpisode.text = info;
}

- (void)showOrHideNextEpisode:(BOOL)isShow{
    self.viewNextEpisode.hidden = !isShow;
}

- (void)showControlAtPauseStatus:(BOOL)willShow {
    self.btnPlayPause.selected = !willShow;
}

#pragma mark - ChannelListListenerEvent

- (void)show {
   }

- (void)loadChannelList {
  
}

- (void)channeListClose {
    
    self.btnTVChannels.selected = NO;
    self.btnTVChannelsArrow.selected = NO;
}

- (void)reloadMediaUrlForPiPFullscreen {
 
}

@end
