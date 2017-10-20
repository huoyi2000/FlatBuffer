//
//  ViewController.m
//  FlatBufferDemo
//
//  Created by  壹件事 on 2017/10/20.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import "ViewController.h"
#import "GCDSocketLongLink.h"
#import "ServerInfo.h"

#define dns_server_domain (@"data.51miaohui.com")
#define dns_socket_port (80)

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - LifeCycle

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidConnect:) name:didConnectToHostNotification object:nil];
    //连接服务器
    [GCDSocketLongLink connectToHost:dns_server_domain onPort:dns_socket_port];
}

#pragma mark - Notification

- (void)socketDidConnect:(NSNotification *)notify
{
    NSLog(@"%s",__func__);
    ServerInfoReq *req = [[ServerInfoReq alloc] init];
    req.netType = 1;
    [GCDSocketLongLink send:req recv:^(ServerInfoRep *rep, NSError *err) {
        NSLog(@"");
    }];
}

@end
