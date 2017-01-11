//
//  FileAccessor.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_FileAccessor_h
#define YANSIS_FileAccessor_h

#import<Foundation/Foundation.h>

@interface FileAccessor : NSObject
-(id)initWithFile:(NSString *)filename;
-(void)seek:(unsigned long long)pos;
-(UInt16)readShort;
-(UInt32)readInt;
-(unsigned long long)length;
-(void)close;
@end
#endif
