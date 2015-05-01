//
//  PlayerView.h
//  TelenorMyTV
//
//  Created by Nguyen Tan Thanh on 2/10/15.
//  Copyright (c) 2015 UUX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PlayerControl.h"
#import <AVFoundation/AVFoundation.h>


@class AVPlayer;
@class DetailDataManager;
@class AVPlayerView;

@interface PlayerView : UIView <PlayerControlDelegate>
{
    NSTimer *offsetTimer;
    NSTimer *progressTimer;
    
    AVPlayer* _avPlayer;
    AVPlayerItem * _avPlayerItem;
    
    AVURLAsset *_avAsset;
}


//controll parameter
@property (weak, nonatomic) IBOutlet UIView *loadView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aivLoading;
@property (weak, nonatomic) IBOutlet UILabel *lbLoading;
@property (weak, nonatomic) IBOutlet UILabel *lbError;

@property (weak, nonatomic) IBOutlet UIButton *btnPiPClose;
@property (weak, nonatomic) IBOutlet UIButton *btnPiPZoom;
@property (strong, nonatomic) IBOutlet UIView *pipView;

@property (weak, nonatomic) IBOutlet UIButton *btnPreChannel;
@property (weak, nonatomic) IBOutlet UIButton *btnNextChannel;
@property (weak, nonatomic) IBOutlet UILabel *lblPreChannel;
@property (weak, nonatomic) IBOutlet UILabel *lblNextChannel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *aivLoadingPiP;
@property (weak, nonatomic) IBOutlet UILabel *lblPiPMessage;

- (IBAction)btnChannel_Click:(UIButton *)sender;


//public parameter
@property (strong, nonatomic) PlayerControl *playerControl;
//@property (strong, nonatomic) MPMoviePlayerController *playerController;
@property (strong, nonatomic) id delegate;
@property BOOL isFullScreen;
@property BOOL isEpisodes;
@property BOOL isFromMiniMode;
@property BOOL isReadyPiPToFullScreen;
@property BOOL isShowingUpsell;
@property BOOL isLoadingVideo;
@property (strong, nonatomic) DetailDataManager *detailDataManager;
@property CGFloat playBackAtTime;
@property (strong, nonatomic) AVPlayerView *avPlayerView;
@property (readwrite, strong, setter=setPlayer:, getter=player) AVPlayer *avPlayer;
@property (strong, nonatomic) AVPlayerItem *avPlayerItem;
@property (strong, nonatomic) AVPlayer *pipAVPlayer;
@property (strong, nonatomic) AVPlayerLayer *pipAVPlayerLayer;

@property (strong , nonatomic) NSArray *arrEpisodes;
@property (readwrite , nonatomic) int currentEpisodeIndex;
@property (strong , nonatomic) NSString *currentSeasonNumber;

//Method
+ (instancetype)createWithDelegate:(id)delegate;

- (void)playAtMiniPlayerMode;
- (void)playAtFullScreenMode;
- (void)play;
- (void)pause;
- (void)stop;
- (void)destroyPlayer;
- (void)resume;
- (void)setMediaPosition:(int)playbackTime;
- (CGFloat)getMediaOffset;
- (void)showOrHideLoadingStatus:(BOOL)willShow;
- (void)requestNextEpisode;
- (void)appDidRotate;
- (void)showOrHideErrorStatus:(BOOL)willShow;
- (IBAction)closePiPPlayer:(id)sender;
- (IBAction)showPiPAtFullscreen:(id)sender;
- (void)destroyPiPPlayer;
- (void)showPipView:(BOOL)show;
- (void)showPreNextChannelButton:(BOOL)isNext andShow:(BOOL)show;

@end
