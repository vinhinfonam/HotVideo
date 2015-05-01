//
//  PlayerControl.h
//  TelenorMyTV
//
//  Created by Nguyen Tan Thanh on 2/10/15.
//  Copyright (c) 2015 UUX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"

@protocol PlayerControlDelegate <NSObject>

@end

@class PlayerView;


@interface PlayerControl : UIView

@property (weak, nonatomic) id<PlayerControlDelegate> delegate;

//Top controls
@property (weak, nonatomic) IBOutlet UIView *topControl;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIView *fullscreenTopControl;
@property (weak, nonatomic) IBOutlet UISlider *volumnBar;
@property (weak, nonatomic) IBOutlet UIButton *btnTVChannels;
@property (weak, nonatomic) IBOutlet UIButton *btnTVChannelsArrow;
@property (weak, nonatomic) IBOutlet UIImageView *imgChannel;
@property (weak, nonatomic) IBOutlet UILabel *txtMovieTitle;
@property (weak, nonatomic) IBOutlet UIImageView *bgChannelView;
@property (weak, nonatomic) IBOutlet UIButton *btnChromeCast;
@property (weak, nonatomic) IBOutlet UIButton *btnLanguage;

//Bottom controls
@property (weak, nonatomic) IBOutlet UIView *bottomControl;
@property (weak, nonatomic) IBOutlet UIButton *btnPlayPause;
@property (weak, nonatomic) IBOutlet UIButton *btnZoom;
@property (weak, nonatomic) IBOutlet UIView *fullscreenBottomControl;
@property (weak, nonatomic) IBOutlet UILabel *txtLiveTitle;
@property (weak, nonatomic) IBOutlet UISlider *videoProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaybackTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;

// Next episode controls
@property (weak, nonatomic) IBOutlet UIView *viewNextEpisode;
@property (weak, nonatomic) IBOutlet UILabel *lblNextEpisode;
@property (weak, nonatomic) IBOutlet UIButton *btnNextEpisode;

@property (weak, nonatomic) PlayerView *playerView;
@property BOOL isLiveStream;
@property BOOL isCatchupTV;

@property (strong, nonatomic)  NSMutableArray *listLive;
@property (strong, nonatomic) NSDictionary *poster;

@property (assign, nonatomic) int selectedLanguage;

@property (strong, nonatomic) NSArray *languageList;

@property BOOL forceToMiniMode;
@property NSString *episodeMovieTitle;
@property int currentPiPChannelIndex;

+ (instancetype)createWithPlayerView:(PlayerView *)playerView;

- (IBAction)btnCloseClicked:(UIButton *)sender;
- (IBAction)btnTVChannelsClicked:(UIButton *)sender;
- (IBAction)volumnBarValueChanged:(UISlider *)sender;
- (IBAction)btnPlayPauseClicked:(UIButton *)sender;
- (IBAction)btnZoomClicked:(UIButton *)sender;
- (IBAction)videoProgressBarValueChanged:(UISlider *)sender;
- (IBAction)btnNextEpisode:(id)sender;
- (IBAction)btnLanguageClicked:(id)sender;

- (void)showOrHideControls:(BOOL)willShow;
- (void)showControlInMiniMode;
- (void)showControlInFullscreenMode;
- (void)updateVideoProgressBar:(float)value;
//- (void)setMinValueForVideoProgressBar:(float)minValue;
//- (void)setMaxValueForVideoProgressBar:(float)maxValue;
- (void)showNextEpisodeInfo:(NSString *) info;
- (void)showNextButton:(BOOL)isShow;
- (void)showOrHideNextEpisode:(BOOL)isShow;
- (void)showControlAtPauseStatus:(BOOL)willShow;
- (void)showChromecastButton:(BOOL) isShow;
- (void)resetControl;
- (void)setVideoDuration:(int)duration;
- (void)showPlaybackTime:(int)currentTime;
- (void)loadChannelList;
- (void)reloadMediaUrlForPiPFullscreen;

@end
