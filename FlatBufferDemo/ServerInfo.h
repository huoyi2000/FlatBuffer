//
//  ServerInfo.h
//  LoginTestDemo
//
//  Created by  壹件事 on 2017/4/11.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Err.h"
#import "FBTable.h"

@interface ServerInfo : NSObject

@end

#pragma mark - ServerInfoData

@interface ServerInfoData : FBTable

@property (nonatomic, strong)NSString *ip;

@property (nonatomic, assign)int32_t port;

@end

#pragma mark - ServerInfoReq

@interface ServerInfoReq : FBTable

@property (nonatomic, assign)int32_t netType;

@end

#pragma mark - ServerInfoRep

@interface ServerInfoRep : FBTable

@property (nonatomic, strong)Err *err;

@property (nonatomic, strong)ServerInfoData *data;

@end

