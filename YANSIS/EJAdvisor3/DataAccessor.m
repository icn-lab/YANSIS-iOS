//
//  DataAccessor.m
//  YANSIS
//
//  Created by 長野雄 on 2015/01/14.
//  Copyright (c) 2015年 長野雄. All rights reserved.
//

#import "DataAccessor.h"

@implementation DataAccessor{
    NSData *data;
    NSUInteger curPos;
    NSUInteger length;
}

-(id)initWithFile:(NSString *)filename{
    if(self = [super init]){
        data = [[NSData alloc] initWithContentsOfFile:filename];
        length = [data length];
        curPos = 0;
        NSLog(@"file:%@, length:%ld bytes", filename, (unsigned long)length);
    }
    
    return self;
}

-(void)seek:(unsigned long long)pos{
    curPos = pos;
}

-(UInt16)readShort{
    UInt16 retval;
    @autoreleasepool {
        NSData *read = [self readDataOfLength:2];
        unsigned char *bytes = (unsigned char *)[read bytes];
        retval = bytes[0] << 8 | bytes[1];
    }
    return retval;
}

-(UInt32)readInt{
    UInt32  retval;
    @autoreleasepool {
        NSData *read = [self readDataOfLength:4];
        unsigned char *bytes = (unsigned char *)[read bytes];
        retval = bytes[0] << 24|bytes[1]<<16|bytes[2]<<8|bytes[3];
    }
    return retval;
}

-(NSData *)readDataOfLength:(NSUInteger)len{
    NSData *retData = [data subdataWithRange:NSMakeRange(curPos, len)];
    curPos += len;
    return retData;
}

-(unsigned long long)length{
    return length;
}

-(void)close{
    data = nil;
}


@end
