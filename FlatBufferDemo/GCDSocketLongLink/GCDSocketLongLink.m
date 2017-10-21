//
//  GCDSocketLongLink.m
//  FlatBufferDemo
//
//  Created by  壹件事 on 2017/10/20.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import "GCDSocketLongLink.h"
#import "GCDAsyncSocket.h"
#import "SLTask.h"
#import "NSData+Util.h"
#import "staticFuncs.h"

NSString *socketDidConnectToHostNotification = @"socketDidConnectToHostNotification";
NSString *socketDidDisconnectNotification = @"socketDidDisconnectNotification";

@interface GCDSocketLongLink ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *longSocket;

@property (nonatomic, strong) dispatch_queue_t delegateQueue;

@property (nonatomic, strong) NSMutableArray <SLTask *> *tasks;

@end

#define kSocketDomain ("com.yjs.kSocketDomain")

@implementation GCDSocketLongLink

static GCDSocketLongLink *inst_socket = nil;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!inst_socket) {
            inst_socket = [[GCDSocketLongLink alloc] init];
        }
    });
    return inst_socket;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.tasks = @[].mutableCopy;
    }
    return self;
}

+ (void)connectToHost:(NSString *)host onPort:(uint32_t)port
{
    [[GCDSocketLongLink sharedInstance] connectToHost:host onPort:port];
}

- (void)connectToHost:(NSString *)host onPort:(uint32_t)port
{
    self.longSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.delegateQueue];
    NSError *err;
    if ([self.longSocket connectToHost:host onPort:port error:&err]) {
        //连接成功
    }
    else {
        //连接失败
        if (err) {
            
        }
    }
}

+ (void)send:(FBTable *)sData recv:(void (^)(id, NSError *))rBlock
{
    [[GCDSocketLongLink sharedInstance] send:sData recv:rBlock];
}

- (void)send:(FBTable *)sData recv:(void (^)(id, NSError *))rBlock
{
    SLTask *task = [[SLTask alloc] init];
    task.sendData = sData;
    task.recvBlock = rBlock;
    [self.tasks addObject:task];
    
    [self sendNextRequest];
}

- (void)sendNextRequest
{
    SLTask *task;
    for (int i = 0; i < self.tasks.count; i++) {
        task = self.tasks[i];
        if (task.state == SLTaskStateExcuting) {
            break;
        }
    }
    
    //先判断有无在执行的任务，没有就启动第一个未开始的任务
    if (task.state == SLTaskStateExcuting) {
        return;
    }
    
    for (int i = 0; i < self.tasks.count; i++) {
        task = self.tasks[i];
        if (task.state == SLTaskStateNotStart) {
            break;
        }
    }
    if (task.state != SLTaskStateNotStart) {
        NSLog(@"所有任务执行完");
        return;
    }
    
    task.state = SLTaskStateExcuting;
    [self.longSocket writeData:[NSData encodeObject:task.sendData] withTimeout:-1 tag:task.tag];
    [self.longSocket readDataWithTimeout:-1 tag:task.tag];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:socketDidConnectToHostNotification object:nil];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"%s",__func__);
    
    //通过tag找到对应的请求
    @synchronized(self)
    {
        SLTask *task = self.tasks[tag-10000];
        if (!task.recvData) {
            task.recvData = [NSMutableData new];
        }
        
        if (data.length) {
            [task.recvData appendData:data];
        }
        
        if (task.recvData.length-16 == [task.recvData repLength]) {
            //请求完成
            NSLog(@"");
            NSData *data_ = [NSData decodeData:task.recvData];
            NSDictionary *dict = getFBConfig(task.sendData);
            Class repCls = NSClassFromString(dict[@"repCls"]);
            id obj = [repCls getRootAs:data_];
            if (task.recvBlock) {
                task.recvBlock(obj, nil);
            }
        }
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] postNotificationName:socketDidDisconnectNotification object:nil];
}

#pragma mark - getters

- (dispatch_queue_t)delegateQueue
{
    if (!_delegateQueue) {
        _delegateQueue = dispatch_queue_create(kSocketDomain, DISPATCH_QUEUE_SERIAL);
    }
    return _delegateQueue;
}

@end
