//
//  Utils.m

#import "Utils.h"
//#import <objc/message.h>


#define CURRENT_VERSION_BUILD @"isFirstLaunch"

@implementation Utils

+ (BOOL)isValidEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isValidPhoneNumber:(NSString *)pNum
{
    if([pNum length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"^(\\d{2}|\\d{2} )\\d{7}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:pNum options:0 range:NSMakeRange(0, [pNum length])];
    
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSDate* )getCurrentHour{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:now];
    return [calendar dateFromComponents:components];
}
+ (NSDate*) appendHour:(NSDate*)currentHour with:(NSInteger)hoursToAdd{
    NSString *strCurrentDate;
    NSString *strNewDate;
    NSDateFormatter *df =[[NSDateFormatter alloc]init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    strCurrentDate = [df stringFromDate:currentHour];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hoursToAdd];
    NSDate *newDate= [calendar dateByAddingComponents:components toDate:currentHour options:0];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterMediumStyle];
    strNewDate = [df stringFromDate:newDate];
    return newDate;
}

+ (NSDate*) setHour:(NSDate*)date with:(NSInteger)hour{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components: NSUIntegerMax fromDate: date];
    [components setHour:hour];
    NSDate *newDate= [calendar dateFromComponents:components];

    return newDate;
}


+(NSString*) getTimeFrom:(NSDate*) date withFormat:(NSString*) format{
    if (date!=nil && !([format isEqualToString:@"hh:mm a"]||[format isEqualToString:@"hh:mm"])) {
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:format];
        return  [timeFormat stringFromDate:date];
    }
    else if (date!=nil && ([format isEqualToString:@"hh:mm a"]||[format isEqualToString:@"hh:mm"])){
        BOOL havePMorAM = [format isEqualToString:@"hh:mm a"];
        NSString *_pm = havePMorAM?@" pm":@"";
        NSString *_am = havePMorAM?@" am":@"";
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
        NSInteger minute = [components minute];
        NSInteger showHour = hour%12;
        return [NSString stringWithFormat:@"%0.2d:%0.2d%@", havePMorAM?(showHour == 0 ? 12: showHour):hour, minute, (int)(hour/12) > 0?_pm:_am];
    }
    else {
        return nil;
    }
}

+ (BOOL) date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate {
    if(beginDate == nil && endDate == nil) return NO;
    return (([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));
}

+ (NSInteger) getHourFrom:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    return [components hour];
}

+ (NSString*)getStringDate:(NSDate*)date withFormat:(NSString*)format andLocaleIdentifier:(NSString*)localeIdentifier{
    NSString *result = @"";
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
        result = [dateFormatter stringFromDate:date];
    }
    @catch (NSException *exception) {
        
    }
    return result;
}

+ (BOOL)isSameDay:(NSDate*)date1 otherDay:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

+ (void)showAlertMessage:(NSString *)message withId:(int)popupId {
    UIAlertView * err = [[UIAlertView alloc] initWithTitle:nil message: message delegate:nil cancelButtonTitle: @"OK" otherButtonTitles: nil ];
    [err show];
    
}

+ (NSString*) formatNumberPhoneUserID:(NSString*)userID withRegion:(NSString*)region{
//    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
//    
//    NSError *anError = nil;
//    NBPhoneNumber *myNumber = [phoneUtil parse:userID
//                                 defaultRegion:region error:&anError];
//    
//    if (anError == nil && [phoneUtil isValidNumber:myNumber]) {
//        return [phoneUtil format:myNumber
//                    numberFormat:NBEPhoneNumberFormatE164
//                           error:&anError];
//        
//    }
//    
    return @"";

}


#pragma mark - Check cellular/3G support on device

+ (bool) hasCellular:(NSString*)modelIdentifier {
    if ([modelIdentifier hasPrefix:@"iPhone"]) return YES;
    if ([modelIdentifier hasPrefix:@"iPod"]) return NO;
    
    if ([modelIdentifier isEqualToString:@"iPad1,1"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad2,1"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad2,2"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad2,3"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad2,4"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad2,5"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad2,6"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad2,7"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad3,1"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad3,2"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad3,3"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad3,4"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad3,5"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad3,6"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad4,1"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad4,2"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad2,5"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad2,6"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad2,7"])      return YES;
    if ([modelIdentifier isEqualToString:@"iPad4,4"])      return NO;
    if ([modelIdentifier isEqualToString:@"iPad4,5"])      return YES;
    
    if ([modelIdentifier isEqualToString:@"i386"])         return NO;
    if ([modelIdentifier isEqualToString:@"x86_64"])       return NO;
    
    return YES;
}

+ (NSComparisonResult)versionCompareBetweenAppVersion:(NSString*)appVersion withCmsVersion:(NSString*)cmsVersion{
    NSArray *arrSubAppVersion = [appVersion componentsSeparatedByString:@"."];
    NSArray *arrSubCmsVersion = [cmsVersion componentsSeparatedByString:@"."];
    int sumSubAppVersion = 0;
    int sumSubCmsVersion = 0;
    for (NSString *str1 in arrSubAppVersion) {
        sumSubAppVersion += [str1 integerValue];
    }
    for (NSString *str2 in arrSubCmsVersion) {
        sumSubCmsVersion += [str2 integerValue];
    }
    int len = MIN(arrSubAppVersion.count, arrSubCmsVersion.count);
    for (int i = 0; i < len; i ++){
        if ([arrSubAppVersion[i] integerValue] > [arrSubCmsVersion[i] integerValue])
            return NSOrderedAscending;
        else if ([arrSubCmsVersion[i] integerValue] > [arrSubAppVersion[i] integerValue])
            return NSOrderedDescending;
        sumSubAppVersion -= [arrSubCmsVersion[i] integerValue];
        sumSubCmsVersion -= [arrSubAppVersion[i] integerValue];
    }
    if (sumSubAppVersion > 0)
        return NSOrderedAscending;
    else if (sumSubCmsVersion > 0)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

+(NSString *)getAgeRatingIcon:(int)age{
    switch (age) {
        case 6:
            return @"age_rating_6";
        case 12:
            return @"age_rating_12";
        case 16:
            return @"age_rating_16";
        case 18:
            return @"age_rating_18";
            
        default:
            return nil;
    }
}
+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (void)forceAppRotateToLandscape:(BOOL)isLandScape {
    
    UIInterfaceOrientation orientation = isLandScape ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
    
    
    void (*response)(id, SEL, NSInteger) = (void (*)(id, SEL, NSInteger)) objc_msgSend;
    
    response([UIDevice currentDevice],@selector(setOrientation:), orientation);
    
    
}

//+ (void)forceAppRotateToLandscapeRightOrLeft:(BOOL)isRightOrLeft {
//    
//    UIInterfaceOrientation orientation = isRightOrLeft ? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationLandscapeLeft;
//    
//    objc_msgSend([UIDevice currentDevice],@selector(setOrientation:), orientation);
//}

+ (UITextField *)textfieldPaddingLeft:(UITextField *)textField {
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 5, textField.frame.size.height)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

+ (NSString*)replaceBR:(NSString*)str{
    NSString *result = [[[[str stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"] stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
    return result;
}

@end
