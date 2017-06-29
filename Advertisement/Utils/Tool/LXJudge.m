//
//  LXJudge.m
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXJudge.h"
#define currentViewHeight [UIScreen mainScreen].bounds.size.height
#define currentViewWidth [UIScreen mainScreen].bounds.size.width
#define iphone6Width 375.f
#define iphone6Height 667.f
@implementation LXJudge

#pragma mark - NSString

// 判断字符串是否为空
+ (BOOL)isBlankOfString:(NSString *)originString {
    if (originString == nil) {
        return YES;
    }
    
    if (originString == NULL) {
        return YES;
    }
    
    if ([originString isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[originString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

// 判断是否为有效手机号
+ (BOOL)isPhoneNumberFormatOfString:(NSString *)originString {
    BOOL isValid;
    
    NSString* textRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    if ([predicate evaluateWithObject:originString]) {
        isValid = TRUE;
    }
    else {
        isValid = FALSE;
    }
    
    return isValid;
}

// 判断是否为有效邮箱
+ (BOOL)isEmailFormatOfString:(NSString *)originString {
    BOOL isValid;
    
    NSString* textRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    if ([predicate evaluateWithObject:originString]) {
        isValid = TRUE;
    }
    else {
        isValid = FALSE;
    }
    
    return isValid;
}

// 判断是否为有效验证码
+ (BOOL)isVerifyCode:(NSString *)originString {
    BOOL isValid;
    
    NSString* textRegex = @"^[0-9]{6}$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    if ([predicate evaluateWithObject:originString]) {
        isValid = TRUE;
    }
    else {
        isValid = FALSE;
    }
    
    return isValid;
}

// 判断是否为密码格式：6-16位数字、字母组合
+ (BOOL)isPasswordFormatOfString:(NSString *)originString {
    BOOL isCorrect;
    
    NSString* textRegex = @"^([A-Za-z0-9]|[._!@#$%^*()_=+-]){6,18}$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    
    if ([predicate evaluateWithObject:originString]) {
        isCorrect = TRUE;
    }
    else {
        isCorrect = FALSE;
    }
    
    return isCorrect;
}

// 判断是否为数字格式
+ (BOOL)isNumberformatOfString:(NSString *)originString {
    BOOL isCorrect;
    
    NSString* textRegex = @"^[0-9]+$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    
    if ([predicate evaluateWithObject:originString]) {
        isCorrect = TRUE;
    }
    else {
        isCorrect = FALSE;
    }
    
    return isCorrect;
}

// 判断是否为QQ格式
+ (BOOL)isQQFormatOfString:(NSString *)originString {
    BOOL isCorrect;
    
    NSString* textRegex = @"^[1-9]\\d{4,10}$";
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", textRegex];
    
    if ([predicate evaluateWithObject:originString]) {
        isCorrect = TRUE;
    }
    else {
        isCorrect = FALSE;
    }
    
    return isCorrect;
}

// 判断是否为合法身份证号
+ (BOOL)isIdentityCardOfString:(NSString *)sourceString {
    BOOL isValid;
    
    if (sourceString.length <= 0) {
        isValid = NO;
        
        return isValid;
    }
    NSString *stringRegular = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",stringRegular];
    
    return [identityCardPredicate evaluateWithObject:sourceString];
}

// 判断是否为合法车牌号
+ (BOOL)isCarNoOfString:(NSString *)sourceString {
    NSString *carRegular = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";
    NSPredicate *carPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegular];
    
    return [carPredicate evaluateWithObject:sourceString];
}

// 判断是否为汉字
+ (BOOL)isChineseCharacter:(NSString *)sourceString {
    BOOL isValid;
    
    if (sourceString.length <= 0) {
        isValid = NO;
        
        return isValid;
    }
    
    NSString *stringRegular = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",stringRegular];
    
    return [identityCardPredicate evaluateWithObject:sourceString];
}
#pragma mark - 获取某个长度在不同设备上的绝对长度
+(CGFloat)convertWidthWithWidth:(CGFloat)width
{
    CGFloat newWidth = currentViewWidth*width/iphone6Width;
    return newWidth;
}

#pragma mark - 获取某个长度在不同设备上的绝对长度
+(CGFloat)convertHeightWithHeight:(CGFloat)height
{
    CGFloat deviceHeight = 0.f;
    
    deviceHeight=currentViewHeight;
    
    CGFloat newHeight = deviceHeight*height/iphone6Height;
    return newHeight;
}



@end
