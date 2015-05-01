//
//  PlayerView.m

#import "PlayerView.h"
#import "PlayerGestureRegconize.h"
#import "AVPlayerView.h"
#import "Constant.h"

#define kStatusKey      @"status"
#define kRateKey      @"rate"
#define kCurrentItemKey      @"currentItem"
#define kPiPStatusKey      @"pipstatus"

@implementation PlayerView{

}

static void *AVPlayerRateObservationContext = &AVPlayerRateObservationContext;
static void *AVPlayerStatusObservationContext = &AVPlayerStatusObservationContext;
static void *AVPlayerCurrentItemObservationContext = &AVPlayerCurrentItemObservationContext;

static void *AVPlayerPiPStatusObservationContext = &AVPlayerPiPStatusObservationContext;

@synthesize isFullScreen;
@synthesize isFromMiniMode;
@synthesize avPlayerItem, avPlayer, avPlayerView;

#pragma mark - Delegate
+ (instancetype)createWithDelegate:(id)delegate {
    PlayerView *player = [[[NSBundle mainBundle] loadNibNamed:@"PlayerView" owner:self options:nil] lastObject];
    player.delegate = delegate;
    
    UIViewController *parentVC = delegate;
    [parentVC.view addSubview:player];
    [parentVC.view bringSubviewToFront:player];
    
    return player;
}

- (void)awakeFromNib {
   
    [self initPlayer];
    
    //Register orientation
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(changeOrientationNotification:)
                                                 name: UIDeviceOrientationDidChangeNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActiveNotification:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActiveNotification:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:NULL];
   
}

#pragma mark - Create Player
- (void)initPlayer {
    
    self.avPlayerView = [[AVPlayerView alloc] init];
    self.avPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.avPlayerView];
    [self sendSubviewToBack:self.avPlayerView];
    
    //Init player Control (Play - Pause - Zoom)
    self.playerControl = [PlayerControl createWithPlayerView:self];
//    [self bringSubviewToFront:self.playerControl];
    self.playerControl.delegate = self;
    //show loading
    self.lbLoading.text = @"Loading...";// [MessageUtil getMessage:@"loading_video_message"];
    [self showOrHideLoadingStatus:YES];
    
    [self playAtMiniPlayerMode];

}

- (void)playWithUrl:(NSURL *)mediaUrl {
    
    _avAsset = [AVURLAsset URLAssetWithURL:mediaUrl options:nil];
    //[asset chapterMetadataGroupsBestMatchingPreferredLanguages:@[@"hu", @"en"]];
    
    NSArray *requestedKeys = @[@"playable"];
    
    /* Tells the asset to load the values of any of the specified keys that are not already loaded. */
    [_avAsset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
         dispatch_async( dispatch_get_main_queue(),^{
                            /* IMPORTANT: Must dispatch to main queue in order to operate on the AVPlayer and AVPlayerItem. */
                            [self prepareToPlayAsset:_avAsset withKeys:requestedKeys];
                        });
     }];
    
}

- (void)showPreNextChannelButton:(BOOL)isNext andShow:(BOOL)show{
    if(!isNext){
        self.btnPreChannel.hidden = !show;
        self.lblPreChannel.hidden = !show;
        
        self.btnNextChannel.hidden = NO;
        self.lblNextChannel.hidden = NO;
    } else{
        self.btnNextChannel.hidden = !show;
        self.lblNextChannel.hidden = !show;
        
        self.btnPreChannel.hidden = NO;
        self.lblPreChannel.hidden = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"=====Touch=====");
    //[self.playerControl channeListClose];
    //[self.playerControl closeLanguageList];
    
}

#pragma mark Prepare to play asset, URL
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys{
    for (NSString *thisKey in requestedKeys){
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed){
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
    }
    
    /* Use the AVAsset playable property to detect whether the asset can be played. */
    if (!asset.playable){
        [self assetFailedToPrepareForPlayback:nil];
        
        return;
    }
    
    
    if (self.avPlayerItem){
        [self.avPlayerItem removeObserver:self forKeyPath:kStatusKey];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:AVPlayerItemDidPlayToEndTimeNotification
                                                      object:self.avPlayerItem];
    }
    
    self.avPlayerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.avPlayerItem addObserver:self
                       forKeyPath:kStatusKey
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:AVPlayerStatusObservationContext];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.avPlayerItem];

    if (!self.avPlayer){
        [self setPlayer:[AVPlayer playerWithPlayerItem:self.avPlayerItem]];
        [self.player addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerCurrentItemObservationContext];
        
        [self.player addObserver:self
                      forKeyPath:kRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:AVPlayerRateObservationContext];
    }
    
    if (self.player.currentItem != self.avPlayerItem){
        [self.avPlayer replaceCurrentItemWithPlayerItem:self.avPlayerItem];
    }
    
    [self.player play];
    
    [self performSelector:@selector(hideLoadingView) withObject:nil afterDelay:60];
    
    
}

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context{
    
    if (context == AVPlayerStatusObservationContext){
        self.isLoadingVideo = NO;
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status){
            case AVPlayerItemStatusUnknown:
                break;
                
            case AVPlayerItemStatusReadyToPlay:{
                
                [self showOrHideLoadingStatus:NO];
                
            }
            break;
                
            case AVPlayerItemStatusFailed:{
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
        }
    }else if (context == AVPlayerRateObservationContext){
      
    }else if (context == AVPlayerCurrentItemObservationContext){
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (newPlayerItem == (id)[NSNull null]){
        }
        else{
            [self.avPlayer setAllowsExternalPlayback:YES];
            [(AVPlayerLayer*)[self.avPlayerView layer] setPlayer:self.avPlayer];
        }
    } else{
        [super observeValueForKeyPath:path ofObject:object change:change context:context];
    }
    
}

- (void)hideLoadingView{
     [[self loadView] setHidden:YES];
}

#pragma mark -
#pragma mark Asset Key Value Observing
#pragma mark

/* Called when the player item has played to its end time. */
- (void)playerItemDidReachEnd:(NSNotification *)notification{
    
    [self stop];
    [self.avPlayerItem seekToTime:kCMTimeZero];
   
}

#pragma mark - AVPlayer
#pragma mark Error Handling - Preparing Assets for Playback Failed

-(void)assetFailedToPrepareForPlayback:(NSError *)error{
    [self showOrHideErrorStatus:YES];
}



- (void)playAtMiniPlayerMode {
    
    self.isFromMiniMode = YES;
    
    UIViewController *parentVC = self.delegate;
    [parentVC.view bringSubviewToFront:self];
    
    //set frame
    self.frame = [Constant miniPlayerFrame];
    [self.playerControl showControlInMiniMode];
    //self.playerController.view.frame = self.bounds;
    self.avPlayerView.frame = self.bounds;
    
    //================ Animation ============
    
    self.alpha = 0.0f;
    [UIView animateWithDuration:0.5
                     animations:^{                         
                         self.alpha = 1.0f;
                     }];
    //=======================================


    [self.playerControl showOrHideNextEpisode:NO];

    //add pan gesture
    [[PlayerGestureRegconize sharedInstance] removeGesture];
    [[PlayerGestureRegconize sharedInstance] addPanGestureForPlayerView:self];
}

- (void)playAtFullScreenMode {
    
    UIViewController *parentVC = self.delegate;
    [parentVC.view bringSubviewToFront:self];
    
    //set frame
    CGSize SCREEN_SIZE = [Constant screenSize];
    self.frame = CGRectMake(0, 0, SCREEN_SIZE.height, SCREEN_SIZE.width);    
    self.avPlayerView.frame = self.bounds;
    
   // [self loadNextEpisode];
    [self.playerControl showControlInFullscreenMode];

    //add pinch gesture
    [[PlayerGestureRegconize sharedInstance] removeGesture];
    [[PlayerGestureRegconize sharedInstance] addPinGestureForPlayerView:self];
}

- (void)destroyPlayer {
    
    // Quit Airplay
     [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
    
    [self stop];
    
    [self.avPlayer removeObserver:self forKeyPath:kRateKey];
    [self.avPlayer removeObserver:self forKeyPath:kCurrentItemKey];
    [self.avPlayerItem removeObserver:self forKeyPath:kStatusKey];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.delegate = nil;
    //self.playerController = nil;
    self.avPlayer = nil;
    self.avPlayerItem = nil;
    self.avPlayerView = nil;
    
    //remove gesture
    [[PlayerGestureRegconize sharedInstance] removeGesture];
    [self removeFromSuperview];
}

#pragma mark - Play Event

- (void)play {
    //_videoDidEnd = NO;
    [self.playerControl resetControl];
    //[self.playerController play];
    [self.avPlayer play];
    
}

- (void)pause {
    self.playBackAtTime = [self.avPlayerItem currentTime].value; // [self.playerController currentPlaybackTime];    
    [self.avPlayer pause];
    
    [self.playerControl showControlAtPauseStatus:NO];
}

- (void)stop {
    
    //[self.avPlayer seekToTime:CMTimeMake(0, 1)];
    [self pause];
}

- (void)resume {
//    [self.playerController prepareToPlay];
//    [self.playerController setInitialPlaybackTime:self.playBackAtTime];
//    [self play];
    
    [self.avPlayer play];
}

- (void)finishSendPlaybackOfset:(BOOL) isSuccess{
    
    if(isSuccess){
        DLog(@"FinishSendPlaybackOfset");
    }
}

#pragma mark - Loading controll

- (void)showOrHideLoadingStatus:(BOOL)willShow {
    
    self.loadView.hidden = !willShow;
}

- (void)showOrHideErrorStatus:(BOOL)willShow {
    
    self.lbError.hidden = !willShow;
    if (willShow) {
        [self showOrHideLoadingStatus:NO];
        
        //TO-DO: show ERROR message
        //        self.lbError.text = [MessageUtil getMessage:@"error"];

        
        [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
        
        [self.playerControl.btnLanguage setHidden:YES];
        
    }
    else {
        //TO-DO: hide ERROR message
        //        self.lbError.hidden = willShow;
    }
    self.lbError.text = @"Video error";
}

#pragma mark - Orientation

- (void)changeOrientationNotification:(NSNotification *)notification {
    [self performSelector:@selector(appDidRotate) withObject:nil afterDelay:0.1];
}

- (void)appDidRotate {

    BOOL willFullscreen = ! self.playerControl.forceToMiniMode
                            && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    
    self.playerControl.forceToMiniMode = NO;

    DLog(@" willFullscreen: %d, self.isFullScreen: %d", willFullscreen, self.isFullScreen);
    
    //return when it's called many times
    if (self.isFullScreen == willFullscreen) return;
    
    self.isFullScreen = willFullscreen;
    
     [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    if (self.isFullScreen) {
        [self playAtFullScreenMode];
    }
    else {
        [self playAtMiniPlayerMode];
    }
}

#pragma mark - Become
- (void)applicationWillResignActiveNotification:(NSNotification*)notification {
    DLog(@"applicationWillResignActiveNotification = %@", notification);
    
}

- (void)applicationDidBecomeActiveNotification:(NSNotification*)notification {
    
    DLog(@"applicationDidBecomeActiveNotification = %@", notification);
    [self pause];
}

@end
