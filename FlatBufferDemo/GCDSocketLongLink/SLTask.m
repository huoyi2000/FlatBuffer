//
//  SLTask.m
//  FlatBufferDemo
//
//  Created by  壹件事 on 2017/10/20.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import "SLTask.h"

@implementation SLTask

static NSInteger taskBaseTag = 10000;
- (instancetype)init
{
    if (self = [super init]) {
        self.state = SLTaskStateNotStart;
        self.tag = taskBaseTag++;
    }
    return self;
}

@end
