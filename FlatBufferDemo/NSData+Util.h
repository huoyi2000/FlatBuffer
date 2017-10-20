//
//  NSData+Util.h
//  LoginTestDemo
//
//  Created by  壹件事 on 2017/4/8.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark 发送／响应数据编码解码
@class  FBTable;
@interface NSData (SocketUtil)


/**
 解密(解析前16位信息)

 @param data 解密前的data
 @return 加密后的data
 */
+ (NSData *)decodeData:(NSData *)data;


/**
 加密(加16位头)

 @param obj 加密前的请求对象
 @return 加密后的data
 */
+ (NSData *)encodeObject:(FBTable *)obj;

- (NSInteger)repLength;

- (NSInteger)serviceId;

@end
