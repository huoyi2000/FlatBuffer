//
//  SLTask.h
//  FlatBufferDemo
//
//  Created by  壹件事 on 2017/10/20.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBTable.h"

typedef NS_ENUM(NSInteger, SLTaskState) {
    SLTaskStateNotStart,
    SLTaskStateExcuting,
    SLTaskStateSuccess,
    SLTaskStateFail
};

@interface SLTask : NSObject

@property (nonatomic, strong) FBTable *sendData;

@property (nonatomic, assign) void (^recvBlock)(id rep,NSError *err);

@property (nonatomic, assign) SLTaskState state;

@property (nonatomic, assign) NSInteger tag;

@end
