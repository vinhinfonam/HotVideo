//
//  Utils.h
//  TelenorMyTV
//
//  Created by Binh Le on 8/25/14.
//  Copyright (c) 2014 UUX. All rights reserved.
//




#import <Foundation/Foundation.h>

@class WebCMSDataManager;


#define kRatingAppId @"762539313"

#define IS_LIVE_ENABLE [[WebCMSDataManager sharedManager].configs[@"sidemenu.livetv.enable"] boolValue]
#define IS_RECORD_ENABLE [[WebCMSDataManager sharedManager].configs[@"sidemenu.recorded_tv.enable"] boolValue]




typedef enum {
    PASSWORD_VERIFICATION_OK,
    PASSWORD_VERIFICATION_CURRENT_PASS_BLANK,
    PASSWORD_VERIFICATION_CURRENT_NEW_PASS_BLANK,
    PASSWORD_VERIFICATION_NOT_MATCH,
    PASSWORD_VERIFICATION_SHORT_PASS
    
} PASSWORD_VERIFICATION;

@interface Utils : NSObject <UIAlertViewDelegate>

+ (NSString *)getBrand;
+ (NSString *)getLang;
+ (BOOL)isValidEmail:(NSString*) emailString;
+ (BOOL)isValidPhoneNumber:(NSString *)pNum;
+ (NSDate* )getCurrentHour;
+ (NSDate*) appendHour:(NSDate*)currentHour with:(NSInteger)hoursToAdd;
+ (NSDate*) setHour:(NSDate*)date with:(NSInteger)hour;
+ (NSString*) getTimeFrom:(NSDate*) date withFormat:(NSString*) format;
+ (NSInteger) getHourFrom:(NSDate*)date;
+ (BOOL) date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+ (NSString*)getStringDate:(NSDate*)date withFormat:(NSString*)format andLocaleIdentifier:(NSString*)localeIdentifier;
+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2;
+ (NSString*) formatNumberPhoneUserID:(NSString*)userID withRegion:(NSString*)region;
+ (NSString *) getStringValueForKeyFromEnvPlist:(NSString *) key;
+ (bool) hasCellular:(NSString*)modelIdentifier;
+ (NSString*)deviceModel;
+ (void)showAlertMessage:(NSString *)message withId:(int)popupId;
+ (NSComparisonResult)versionCompareBetweenAppVersion:(NSString*)appVersion withCmsVersion:(NSString*)cmsVersion;
+ (bool)isGeoBlock;
+ (NSString *)getAgeRatingIcon:(int)age;
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (void)forceAppRotateToLandscape:(BOOL)isLandScape;



@end
