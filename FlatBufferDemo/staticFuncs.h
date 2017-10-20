//
//  staticFuncs.h
//  LoginTestDemo
//
//  Created by  壹件事 on 2017/4/6.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#ifndef staticFuncs_h
#define staticFuncs_h

#import "FBTable.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

#define fbConfig [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FBConfig" ofType:@"plist"]]


/**
 获取网络配置

 @param method 请求类型字符串
 @return 配置（字典类型）
 */
static inline NSDictionary *getFBConfigByMethod(NSString *method)
{
    NSDictionary *dict_ = nil;
    NSLog(@"%@",fbConfig);
    for (NSString *key in fbConfig) {
        if ([key isEqualToString:method]) {
            dict_ = fbConfig[key];
            break;
        }
    }
    return dict_;
}

static NSArray *fbRequestServiceIds()
{
    NSMutableArray *lst = @[].mutableCopy;
    for (NSString *key in fbConfig) {
        NSDictionary *dict = fbConfig[key];
        [lst addObject:dict[@"serviceId"]];
    }
    return lst;
}


/**
 获取网络配置

 @param obj 请求对象
 @return 配置（字典类型）
 */
static inline NSDictionary *getFBConfig(FBTable *obj)
{
    NSString *cls = NSStringFromClass([obj class]);
    
    NSDictionary *dict = getFBConfigByMethod(cls);
    
    if (!dict) {
        NSLog(@"找不到该接口对应的配置项，请检查FBConfig.plist");
        return nil;
    }
    
    return dict;
}


/**
 获取网络配置

 @param tag 请求的tag值
 @return 配置（字典类型）
 */
static inline NSDictionary *getFBConfigByTag(int tag)
{
    for (NSString *key in fbConfig) {
        if (tag == [fbConfig[key][@"tag"] intValue]) {
            return fbConfig[key];
        }
    }
    return nil;
}


/**
 颜色合成图片

 @param clr 颜色
 @return 图片
 */
static inline UIImage* imageWithColor(UIColor *clr)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [clr CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


/**
 md5加密

 @param str 加密前的字符串
 @return 加密后的字符串
 */
static inline NSString *md5(NSString *str)
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)str.length, digest );
    NSMutableString *result = [[NSMutableString alloc] initWithString:@""];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}


/**
 md5加密

 @param data 加密前的data
 @return 加密后的string
 */
static inline NSString *md54Data(NSData *data)
{
    const char* original_str = (const char *)[data bytes];
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5(original_str, (uint)strlen(original_str), digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    
    return [outPutStr lowercaseString];
}


/**
 字典描述

 @param dict 字典
 @return 描述字符串(key1=value1&key2=value2..)
 */
static NSString *dictDesc(NSDictionary *dict)
{
    NSMutableString *cacheKey = @"".mutableCopy;
    if (dict&&[dict isKindOfClass:[NSDictionary class]]) {
        int count = 0;
        for (NSString *key in dict) {
            id value = dict[key];
            if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
                if (count==0) {
                    [cacheKey appendFormat:@"%@=%@",key,value];
                }
                else {
                    [cacheKey appendFormat:@"&%@=%@",key,value];
                }
            }
            count++;
        }
    }
    NSLog(@"cacheKey =  %@",cacheKey);
    return cacheKey;
}

#endif /* staticFuncs_h */
