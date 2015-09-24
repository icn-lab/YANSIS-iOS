//
//  FileAccessor.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "FileAccessor.h"

@implementation FileAccessor{
    NSFileHandle *fh;
    unsigned long long length;
}

-(id)initWithFile:(NSString *)filename{
    if(self = [super init]){
        fh = [NSFileHandle fileHandleForReadingAtPath:filename];
     
        length = [fh seekToEndOfFile];
        NSLog(@"file:%@, length:%lld bytes", filename, length);
        [fh seekToFileOffset:0];
    }
    
    return self;
}

-(void)seek:(unsigned long long)pos{
    [fh seekToFileOffset:pos];
}

-(UInt16)readShort{
    UInt16 retval;
    @autoreleasepool {
    NSData *read = [fh readDataOfLength:2];
    unsigned char *bytes = (unsigned char *)[read bytes];
    retval = bytes[0] << 8 | bytes[1];
    }
    return retval;
}

-(UInt32)readInt{
    UInt32  retval;
    @autoreleasepool {
    NSData *read = [fh readDataOfLength:4];
    unsigned char *bytes = (unsigned char *)[read bytes];
    retval = bytes[0] << 24|bytes[1]<<16|bytes[2]<<8|bytes[3];
    }
    return retval;
}

-(unsigned long long)length{
    return length;
}

-(void)close{
    fh = nil;
}

@end