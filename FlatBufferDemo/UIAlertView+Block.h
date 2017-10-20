//
//  UIAlertView+Block.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by 符现超 on 15/5/9.
//  Copyright (c) 2015年 http://weibo.com/u/1655766025 All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertViewCallBackBlock)(NSInteger buttonIndex);

@interface UIAlertView (Block)<UIAlertViewDelegate>

@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;


/**
 UIAlertView的block模式

 @param alertViewCallBackBlock 回调
 @param title 标题
 @param message 信息
 @param cancelButtonName 取消按钮标题
 @param otherButtonTitles 其他按钮标题（title,title2...形式）
 */
+ (void)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock title:(NSString *)title message:(NSString *)message  cancelButtonName:(NSString *)cancelButtonName otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

@end
