//
//  DataAccessor.h
//  YANSIS
//
//  Created by 長野雄 on 2015/01/14.
//  Copyright (c) 2015年 長野雄. All rights reserved.
//

#ifndef YANSIS_DataAccessor_h
#define YANSIS_DataAccessor_h

#import<Foundation/Foundation.h>
@interface DataAccessor:NSObject
-(id)initWithFile:(NSString *)filename;
-(void)seek:(unsigned long long)pos;
-(UInt16)readShort;
-(UInt32)readInt;
-(NSData *)readDataOfLength:(NSUInteger)len;
-(unsigned long long)length;
-(void)close;
@end
#endif
