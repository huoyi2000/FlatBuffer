//
//  NSData+Util.m
//  LoginTestDemo
//
//  Created by  壹件事 on 2017/4/8.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import "NSData+Util.h"
#import "YMSocketUtils.h"
#import "staticFuncs.h"
#import "UIAlertView+Block.h"

@implementation NSData (SocketUtil)

+ (NSData *)decodeData:(NSData *)data
{
    const Byte *bytes = data.bytes;
    
    if (data.length<=12+4) {
        return nil;
    }
    
    Byte h4[4] = {bytes[0],bytes[1],bytes[2],bytes[3]};
    Byte sericeId[2] = {bytes[4],bytes[5]};
    Byte commandId[2] = {bytes[6],bytes[7]};
    Byte versionId[2] = {bytes[8],bytes[9]};
    Byte reservedId[2] = {bytes[10],bytes[11]};
    Byte repDataLen[4] = {bytes[12],bytes[13],bytes[14],bytes[15]};
    
    NSData *totalLenData = [[NSData alloc] initWithBytes:h4 length:4];
    NSData *serData = [[NSData alloc] initWithBytes:sericeId length:2];
    NSData *cmdData = [[NSData alloc] initWithBytes:commandId length:2];
    NSData *verData = [[NSData alloc] initWithBytes:versionId length:2];
    NSData *revData = [[NSData alloc] initWithBytes:reservedId length:2];
    NSData *repLenData = [[NSData alloc] initWithBytes:repDataLen length:4];
    
    
    if ([YMSocketUtils uint32FromBytes:totalLenData]==0||[YMSocketUtils uint32FromBytes:repLenData]<0) {
        NSLog(@"异常，返回数据总长度为0");
        return nil;
    }
    
    BOOL flag = NO;
    
    NSMutableArray *lst = @[].mutableCopy;
    for (NSString *key in fbConfig) {
        NSDictionary *dict = fbConfig[key];
        [lst addObject:dict[@"serviceId"]];
    }
    
    int serviceId = [YMSocketUtils uint16FromBytes:serData];
    for (NSNumber *num in lst) {
        if (num.integerValue == serviceId) {
            flag = YES;
            break;
        }
    }
    if (!flag) {
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            
        } title:@"提示" message:[NSString stringWithFormat:@"serviceId=%d，请检查FBConfig.plist",serviceId] cancelButtonName:@"好" otherButtonTitles:nil, nil];
        return nil;
    }
    
    NSLog(@"返回数据总长度：%u",[YMSocketUtils uint32FromBytes:totalLenData]);
    NSLog(@"serviceId: %d",[YMSocketUtils uint16FromBytes:serData]);
    NSLog(@"commandId: %d",[YMSocketUtils uint16FromBytes:cmdData]);
    NSLog(@"version: %d",[YMSocketUtils uint16FromBytes:verData]);
    NSLog(@"reservedId: %d",[YMSocketUtils uint16FromBytes:revData]);
    NSLog(@"后面数据长度: %d",[YMSocketUtils uint32FromBytes:repLenData]);
    
    NSData *data_ = [[NSData alloc] initWithBytes:bytes+12+3 length:data.length-12-4];
//    [[DataLock sharedLock] unlock];
    return data_;
}

+ (NSData *)encodeObject:(FBTable *)obj
{
    NSDictionary *dict_ = getFBConfig(obj);
    
    if (!dict_) {
        return nil;
    }
    
    NSMutableData *mData = [NSMutableData data];
    NSData *data = [obj getData];
    [mData appendData:[YMSocketUtils bytesFromUInt32:(uint32_t)data.length+12+4]];
    [mData appendData:[YMSocketUtils bytesFromUInt16:[dict_[@"serviceId"] intValue]]];
    [mData appendData:[YMSocketUtils bytesFromUInt16:[dict_[@"commandId"] intValue]]];
    [mData appendData:[YMSocketUtils bytesFromUInt16:1]];
    [mData appendData:[YMSocketUtils bytesFromUInt16:1]];
    [mData appendData:[YMSocketUtils bytesFromUInt32:(uint32_t)data.length]];
    [mData appendData:data];
    
    NSLog(@"发送数据长度：%ld\n",(long)mData.length);
    return mData;
}

- (NSInteger)serviceId
{
    const Byte *bytes = self.bytes;
    Byte sericeId[2] = {bytes[4],bytes[5]};
    NSData *serData = [[NSData alloc] initWithBytes:sericeId length:2];
    return [YMSocketUtils uint16FromBytes:serData];
}

- (NSInteger)repLength
{
    const Byte *bytes = self.bytes;
    
    if (self.length<=12+3) {
        return 0;
    }
    
    Byte repDataLen[4] = {bytes[12],bytes[13],bytes[14],bytes[15]};
    NSData *repLenData = [[NSData alloc] initWithBytes:repDataLen length:4];
    int idx1 = [YMSocketUtils uint32FromBytes:repLenData];
    
    return idx1;
}

@end
