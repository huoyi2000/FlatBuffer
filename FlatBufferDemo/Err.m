// automatically generated, do not modify !!!

#import "Err.h"

@implementation Err 

- (int32_t) errCode {

    _errCode = [self fb_getInt32:4 origin:_errCode];

    return _errCode;

}

- (void) add_errCode {

    [self fb_addInt32:_errCode voffset:4 offset:4];

    return ;

}

- (NSString *) errMsg {

    _errMsg = [self fb_getString:6 origin:_errMsg];

    return _errMsg;

}

- (void) add_errMsg {

    [self fb_addString:_errMsg voffset:6 offset:8];

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
