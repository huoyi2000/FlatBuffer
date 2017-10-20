//
//  ServerInfo.m
//  LoginTestDemo
//
//  Created by  壹件事 on 2017/4/11.
//  Copyright © 2017年  壹件事. All rights reserved.
//

#import "ServerInfo.h"

@implementation ServerInfo

@end

#pragma mark - ServerInfoData

@implementation ServerInfoData

- (NSString *) ip {
    
    _ip = [self fb_getString:4 origin:_ip];
    
    return _ip;
    
}

- (void) add_ip {
    
    [self fb_addString:_ip voffset:4 offset:4];
    
    return ;
    
}

- (int32_t) port {
    
    _port = [self fb_getInt32:6 origin:_port];
    
    return _port;
    
}

- (void) add_port {
    
    [self fb_addInt32:_port voffset:6 offset:8];
    
    return ;
    
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        bb_pos = 14;
        
        origin_size = 12+bb_pos;
        
        bb = [[FBMutableData alloc]initWithLength:origin_size];
        
        [bb setInt32:bb_pos offset:0];
        
        [bb setInt32:8 offset:bb_pos];
        
        [bb setInt16:8 offset:bb_pos-[bb getInt32:bb_pos]];
        
        [bb setInt16:12 offset:bb_pos-[bb getInt32:bb_pos]+2];
        
    }
    
    return self;
    
}

@end

#pragma mark - ServerInfoReq

@implementation ServerInfoReq

- (int32_t) netType {
    
    _netType = [self fb_getInt32:4 origin:_netType];
    
    return _netType;
    
}

- (void) add_netType {
    
    [self fb_addInt32:_netType voffset:4 offset:4];
    
    return ;
    
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        bb_pos = 12;
        
        origin_size = 8+bb_pos;
        
        bb = [[FBMutableData alloc]initWithLength:origin_size];
        
        [bb setInt32:bb_pos offset:0];
        
        [bb setInt32:6 offset:bb_pos];
        
        [bb setInt16:6 offset:bb_pos-[bb getInt32:bb_pos]];
        
        [bb setInt16:8 offset:bb_pos-[bb getInt32:bb_pos]+2];
        
    }
    
    return self;
    
}

@end

#pragma mark - ServerInfoRep

@implementation ServerInfoRep

- (Err *) err {
    
    _err = [self fb_getTable:4 origin:_err className:[Err class]];
    
    return _err;
    
}

- (void) add_err {
    
    [self fb_addTable:_err voffset:4 offset:4];
    
    return ;
    
}

- (ServerInfoData *) data {
    
    _data = [self fb_getTable:6 origin:_data className:[ServerInfoData class]];
    
    return _data;
    
}

- (void) add_data {
    
    [self fb_addTable:_data voffset:6 offset:8];
    
    return ;
    
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        bb_pos = 14;
        
        origin_size = 12+bb_pos;
        
        bb = [[FBMutableData alloc]initWithLength:origin_size];
        
        [bb setInt32:bb_pos offset:0];
        
        [bb setInt32:8 offset:bb_pos];
        
        [bb setInt16:8 offset:bb_pos-[bb getInt32:bb_pos]];
        
        [bb setInt16:12 offset:bb_pos-[bb getInt32:bb_pos]+2];
        
    }
    
    return self;
    
}

@end


