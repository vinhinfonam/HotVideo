//
//  MiniPlayerGesture.m
//  TelenorMyTV


#import "PlayerGestureRegconize.h"
#import "Constant.h"

typedef enum {
    DIRECTION_UNKNOWN = -1,
    DIRECTION_VERTICAL = 0,
    DIRECTION_HORIZONTAL = 1
} DIRECTION;

@implementation PlayerGestureRegconize {
    UIPanGestureRecognizer *_panGesture;
    UIPinchGestureRecognizer *_pinGesture;
    
    CGPoint _startPoint;
    DIRECTION _direction;
    
    NSTimeInterval currentTimeCallForceToMiniMode;
}

static PlayerGestureRegconize *shareInstance = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        shareInstance = [[PlayerGestureRegconize alloc] init];
    });
    return shareInstance;
}

- (void)addPanGestureForPlayerView:(PlayerView *)playerView {

    self.playerView = playerView;
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognize:)];
    _panGesture.delegate = self;
    [playerView addGestureRecognizer:_panGesture];
   
    _startPoint = CGPointZero;
}

- (void)addPinGestureForPlayerView:(PlayerView *)playerView {
   
    self.playerView = playerView;
    _pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinGestureRecognize:)];
    _pinGesture.delegate = self;
    [playerView addGestureRecognizer:_pinGesture];
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handlePanGestureRecognize:(UIPanGestureRecognizer *)panGesture {

    CGPoint location = [_panGesture locationInView:_playerView];
    CGPoint movedPoint = CGPointMake(location.x - _startPoint.x, location.y - _startPoint.y);
    
    switch ( _panGesture.state )
    {
        //Start drag
        case UIGestureRecognizerStateBegan:
        {
            _startPoint = location;
            
            _direction = DIRECTION_UNKNOWN;
        }
            break;
          
        //Do dragging
        case UIGestureRecognizerStateChanged:
        {

            if (_direction == DIRECTION_UNKNOWN) {
               CGPoint velocity = [panGesture velocityInView:self.playerView];
                _direction = fabs(velocity.x) > fabs(velocity.y);
                
            }

            if (_direction == DIRECTION_HORIZONTAL) {
                [self movePlayerWithX:movedPoint.x];
            }
            else if ( _direction == DIRECTION_VERTICAL){
              
                [self moveAndZoomWithPoint:movedPoint];
            }
            
        }
            break;
            
        //End drag
        case UIGestureRecognizerStateEnded:
        {
            if (_direction == DIRECTION_HORIZONTAL) {
                [self closeMiniPlayerOrGetBack];
            }
            else if ( _direction == DIRECTION_VERTICAL ) {
                [self miniPlayerToFullScreenOrGetBack];
            }
            
            _startPoint = CGPointZero;
        }
            break;
            
        default:
            break;
    }

}

- (void)movePlayerWithX:(int)x {
    //Move player view
    self.playerView.frame = CGRectSetX(self.playerView.frame, self.playerView.frame.origin.x + x);
    
    //Set transparent for Player when dragging
    _playerView.alpha = 1.0 - fabs(self.playerView.frame.origin.x - [Constant miniPlayerFrame].origin.x)/ (IS_IPAD ? 400.0 : 200.0);
}

- (void)closeMiniPlayerOrGetBack {
    int minX = 0;
    int maxX = [Constant screenSize].width - [Constant miniPlayerFrame].size.width*1/2;
    int x = _playerView.frame.origin.x;
    
    //Get play back orginal postion.
    if ( minX <= x && x <= maxX ) {
        _playerView.frame = [Constant miniPlayerFrame];
    }
    //Close player
    else
    {

    }
    
    _playerView.alpha = 1.0;
}

- (void)moveAndZoomWithPoint:(CGPoint)point {
  
    CGRect newFrame = CGRectZero;
    newFrame.origin.y = self.playerView.frame.origin.y + point.y;
    
    float miniPlayerW = [Constant miniPlayerFrame].size.width;
    float miniPlayerH = [Constant miniPlayerFrame].size.height;
    float appendW = - ([Constant screenSize].width - miniPlayerW) * point.y / ([Constant screenSize].height - miniPlayerH);
    newFrame.size.width = self.playerView.frame.size.width + appendW;
    newFrame.size.height = newFrame.size.width * miniPlayerH / miniPlayerW;
    newFrame.origin.x = [Constant screenSize].width - 2 - newFrame.size.width;
    
    self.playerView.frame = newFrame;
    //[self.playerView.avPlayerView setFrame:self.playerView.bounds];
}

- (void)miniPlayerToFullScreenOrGetBack {
   
    //Fullscreen
    if (self.playerView.frame.origin.y <= [Constant screenSize].height/2) {
        [self.playerView.playerControl performSelector:@selector(btnZoomClicked:) withObject:nil afterDelay:0.1];
    }
    // Get back
    else {
        self.playerView.frame = [Constant miniPlayerFrame];
    }
}

- (void)handlePinGestureRecognize:(UIPinchGestureRecognizer *)pinGesture {

    //Hotfix
    if ( CFAbsoluteTimeGetCurrent() - currentTimeCallForceToMiniMode < 1  )
        return;
    if (pinGesture.scale < 1) {
          DLog(@"UIPinchGestureRecognizer");
          [self.playerView.playerControl performSelector:@selector(btnZoomClicked:) withObject:nil afterDelay:0.1];
    }
    
        currentTimeCallForceToMiniMode = CFAbsoluteTimeGetCurrent();
}

- (void)removeGesture {
    
    //Remove pan gesture
    if (_panGesture != nil) {
        [self.playerView removeGestureRecognizer:_panGesture];
          _panGesture = nil;
    }
    // Remove pin gesture
    if (_pinGesture != nil) {
        [self.playerView removeGestureRecognizer:_pinGesture];
        _pinGesture = nil;

    }
}

- (void)addGestureInto:(PlayerView *)playerView {
    
    [self addPanGestureForPlayerView:playerView];
    [self addPinGestureForPlayerView:playerView];
}


@end
