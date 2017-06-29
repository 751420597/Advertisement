//
//  LXJudge.h
//  Advertisement
//
//  Created by zuolixin on 2017/4/28.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXJudge : NSObject

#pragma mark - NSString

// 判断字符串是否为空
+ (BOOL)isBlankOfString:(NSString *)originString;

// 判断是否为有效手机号
+ (BOOL)isPhoneNumberFormatOfString:(NSString *)originString;

// 判断是否为有效邮箱
+ (BOOL)isEmailFormatOfString:(NSString *)originString;

// 判断是否为有效验证码
+ (BOOL)isVerifyCode:(NSString *)originString;

// 判断是否为密码格式：6-16位数字、字母组合
+ (BOOL)isPasswordFormatOfString:(NSString *)originString;

// 判断是否为数字格式
+ (BOOL)isNumberformatOfString:(NSString *)originString;

// 判断是否为QQ格式
+ (BOOL)isQQFormatOfString:(NSString *)originString;

// 判断是否为合法身份证号
+ (BOOL)isIdentityCardOfString:(NSString *)sourceString;

// 判断是否为合法车牌号
+ (BOOL)isCarNoOfString:(NSString *)sourceString;

// 判断是否为汉字
+ (BOOL)isChineseCharacter:(NSString *)sourceString;

#pragma mark - 获取某个长度在不同设备上的绝对长度
+(CGFloat)convertWidthWithWidth:(CGFloat)width;

#pragma mark - 获取某个长度在不同设备上的绝对长度
+(CGFloat)convertHeightWithHeight:(CGFloat)height;


@end
