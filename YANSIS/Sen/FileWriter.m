//
//  FileWriter.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "FileWriter.h"

@implementation FileWriter{
    NSFileHandle *fh;
}

-(id)initWithString:(NSString *)filename{
    if(self = [super init]){
        fh = [NSFileHandle fileHandleForWritingAtPath:filename];
    }
    
    return self;
}


-(void)writeShort:(short)value{

    NSData *writeData = [NSData dataWithBytes:&value length:2];
    [fh writeData:writeData];

}

-(void)writeInt:(int)value{

    NSData *writeData = [NSData dataWithBytes:&value length:4];
    [fh writeData:writeData];

}

@end

