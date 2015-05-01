//
//  NavigationViewController.m
//

#import "NavigationViewController.h"
#import "LeftmenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface NavigationViewController ()

@property (strong, readwrite, nonatomic) LeftmenuViewController *menuViewController;

@end

@implementation NavigationViewController
@synthesize playerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
    
    //[self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
}

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

- (void) addPlayer{
    if(!self.playerView){
        self.playerView = [PlayerView createWithDelegate:self];
    }
}

#ifdef __IPHONE_6_0
-(NSUInteger)supportedInterfaceOrientations{
    if ( self.playerView.superview != nil && self.playerView.hidden == NO ) {
        
        if ( self.playerView.isFullScreen ) {
            
            if ( self.playerView.playerControl.forceToMiniMode ) {
                return UIInterfaceOrientationMaskAllButUpsideDown;
            }
            else {
                return UIInterfaceOrientationMaskLandscape;
            }
        }
        
        DLog(@"self.Frame = %@", self.view );
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(BOOL)shouldAutorotate {
    return YES;
}
#endif


#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
