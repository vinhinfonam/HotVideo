//
//  Constan.m

#import "Constant.h"

#define kRate   9/16

static CGSize sScreenSize;
static CGRect sMiniPlayerFrame;
static CGRect sPiPPlayerFrame;
static CGRect sPiPPlayerViewFrame;
@implementation Constant

+ (CGSize)screenSize {
    return sScreenSize;
}

+ (CGRect)miniPlayerFrame {
    return sMiniPlayerFrame;
}

+ (CGRect)pipPlayerFrame {
    return sPiPPlayerFrame;
}

+ (CGRect)pipPlayerViewFrame {
    return sPiPPlayerViewFrame;
}

+ (void)initDefaultConstants {
    sScreenSize = [UIScreen mainScreen].bounds.size;
   
    int width = sScreenSize.width/2;
    int height = width * kRate;
    int padding = 2;
    sMiniPlayerFrame = CGRectMake(width - padding, sScreenSize.height - height - padding, width, height);
    
//    
//     //================== PiP screen size =================
//    
//    int controlHeigh = IS_IPAD?90:40;
//    int pipPadding   = 10;
//    
//    int pipWidth = kScreenHight/3;
//    int pipHeigh = pipWidth*kRate + 12;
//    
//    int pipX = kScreenHight - pipWidth;
//    int pipY = kScreenWidth - controlHeigh - pipPadding - pipHeigh;
//    
//    // PiP View Frame
//    sPiPPlayerViewFrame = CGRectMake(pipX, pipY, pipWidth, pipHeigh);
//    
//    // Pip PlayerView Frame
//    int pipPlayerWidth = pipWidth - pipPadding*3;
//    sPiPPlayerFrame = CGRectMake(0, 0, pipPlayerWidth, pipPlayerWidth*kRate);
//    
//    //====================================================
    
}
@end
