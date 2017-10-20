//
//  GCDSocketLongLink.h
//  FlatBufferDemo
//
//  Created by  壹件事 on 2017/10/20.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBTable.h"

FOUNDATION_EXPORT NSString *didConnectToHostNotification;

@interface GCDSocketLongLink : NSObject

+ (void)connectToHost:(NSString *)host onPort:(uint32_t)port;

+ (void)send:(FBTable *)sData recv:(void(^)(id rep,NSError *err))rBlock;

@end
