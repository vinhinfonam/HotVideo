//
//  Constant.h

#ifndef TelenorMyTV_Constant_h
#define TelenorMyTV_Constant_h

#ifdef DEBUG
    #define DLog(fmt, ...) NSLog((@"[%d] %s " fmt), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
    #define DLog( s, ... )
#endif

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define IMG_BY_SCREEN_HEIGHT(imgName) (([[UIScreen mainScreen] bounds].size.height == 568.0) ? [imgName stringByAppendingString:@"-568h"] : imgName)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height > 480.0)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0)
#define IOS_GREATER_OR_EQUAL(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_LESS_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHight    [[UIScreen mainScreen] bounds].size.height

#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)
#define IS_RETINA_HD ([[UIScreen mainScreen] scale] > 2.0)

#define DOCUMENT_DIR [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define LIBRARY_DIR [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]

#define CGRectSetW(r, w)    CGRectMake(r.origin.x, r.origin.y, w, r.size.height)
#define CGRectSetH(r, h)    CGRectMake(r.origin.x, r.origin.y, r.size.width, h)
#define CGRectSetX(r, x)    CGRectMake(x, r.origin.y, r.size.width, r.size.height)
#define CGRectSetY(r, y)    CGRectMake(r.origin.x, y, r.size.width, r.size.height)

#define LANG_HU @"hu_hu"
#define LANG_EN @"en_us"
#define LANG_KEY @"LANG_KEY"
#define DEVICE_MOBILE @"mob"
#define DEVICE_TABLET @"tab"
#define WIFI_ONLY  @"wifionly_key"
#define CARRIER_NETWORK  @"3gwarning_key"  

#define LOGIN_USERNAME @"LOGIN_USERNAME"
#define LOGIN_PASSWORD @"LOGIN_PASSWORD"
#define WALKTHROUGH_KEY @"WALKTHROUGH_KEY"
#define FIRSTCHANGEPASS_KEY @"FIRSTCHANGEPASS_KEY"
#define DONT_SHOW_AGAIN @"DONTSHOWAGAIN"
#define CARRIER_NETWORK_DONT_SHOW_AGAIN @"CARRIERNETWORKDONTSHOWAGAIN"
#define kHASLOGEDIN @"LOGEDIN_KEY"
#define ANONYMOUS_USER @"ANONYMOUS_USER"
#define TOKEN_CUSTOMER_ID @"TOKEN_CUSTOMER_ID"
#define TOKEN_EXPIRATION @"TOKEN_EXPIRATION"
#define TOKEN @"TOKEN"

#define RELOAD_SUBSCRIPTION_NOTIFICATION @"reload_subscription_notification"
#define UPDATE_REMINDER_NOTIFICATION @"update_reminder_notification"
#define UPDATE_REMINDER_LAYOUT @"update_reminder_layout"

#define RELOAD_CHROMECAST_NOTIFICATION @"reloadChromecast_notification"

#define FACEBOOK_APPID @"facebook_api_key"
#define FACEBOOK_LINKURL @"facebook_link_url"


#define NUMBER_OF_ATTEMPTS 3
#define FILE_DOWNLOAD_THRESHOLD 2.2
#define THRESHOLD_BANDWIDTH 175
#define FAIL_COUNT 3
#define DATA_FILE_URL @"http://images.telenorhu.ottcloudservices.com/WebCMS/speedtest.dat"

#define BG_BOTTON_COLOR_NORMAL   [UIColor colorWithRed:0.0f/255.0f green:173.0f/255.0f blue:239.0f/255.0f alpha:1.0f]
#define BG_BOTTON_COLOR_DEFAULT   [UIColor colorWithRed:0.0f/255.0f green:124.0f/255.0f blue:234.0f/255.0f alpha:1.0f]

#define BG_BUTTON_COLOR_SELECTED [UIColor colorWithRed:128.0f/255.0f green:214.0f/255.0f blue:247.0f/255.0f alpha:1.0f]

////////////////////////////////////////////////////////////////////////////////////
//START these constants will be override when call build.sh

//#define WEBCMS_BASE_URL @"http://images.telenorhu.ottcloudservices.com/WebCMS_Dev/"
#define WEBCMS_BASE_URL @"web_cms_base_url"

//END these constants will be override when call build.sh
////////////////////////////////////////////////////////////////////////////////////

#define ON_NOW @"on_now"
#define WATCH_LIST @"watch_list"
#define RECENTLY_WATCHED @"recently_watched"
#define RECOMMENDATIONS_FOR_YOU @"recommendations_for_you"
#define MOST_VIEWED @"most_viewed"
#define RELATED_ITEMS @"related_items"

#define DATE_SELECTION @"DATE_SELECTION"
#define TIME_LINE @"TIME_LINE"

#define REMINDER_KEY @"reminder_key_%@_%@"
#define PROGRAM_ID  @"program_id"
#define NOTIFICATION_INFO_KEY @"notification_info_key"
#define WEEKLY_REMINDER_KEY @"weekly_reminder_key"
#define WEEKLY_REMINDER_VALUE @"weekly_reminder_value_%@"
#define DAILY_REMINDER_KEY @"daily_reminder_key_%@"

#define kReminderWeekly             7*24*60
#define kReminderDaily              24*60

#endif

typedef enum {
    PAGE_TV_IDX = 0,
    PAGE_ARCHIVE_IDX = 1,
    PAGE_MYTV_IDX = 2,
    PAGE_CATALOG_IDX = 3,
    PAGE_SEARCH_IDX = 4,
    PAGE_REMINDER_IDX = 5
    
} PAGE_IDX;

//typedef enum {
//    REMIDER_SETTING = 0,
//    HELP_SETTING = 1,
//    T&Cs_SETTING = 2,
//    SETTING_SETTING = 3,
//    CHANGE_PASSWORD = 4,
//    LOGOUT = 5
//
//} SETTING_OPTION;

#import <Foundation/Foundation.h>

@interface Constant : NSObject

+ (CGSize)screenSize;
+ (CGRect)miniPlayerFrame;
+ (CGRect)pipPlayerFrame;
+ (CGRect)pipPlayerViewFrame;
+ (void)initDefaultConstants;
@end
