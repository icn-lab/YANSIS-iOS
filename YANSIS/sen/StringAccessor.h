//
//  StringAccessor.h
//  YANSIS
//
//  Created by 長野雄 on 2015/01/05.
//  Copyright (c) 2015年 長野雄. All rights reserved.
//

#ifndef YANSIS_StringAccessor_h
#define YANSIS_StringAccessor_h

#import<Foundation/Foundation.h>

@interface StringAccessor: NSObject
-(id)initWithFile:(NSString *)filename;
-(id)initWithFile:(NSString *)filename encoding:(NSStringEncoding)_encoding;
-(id)initWithString:(NSString *)string;
-(NSString *)readLine;
-(NSStringEncoding)getEncoding;
-(Boolean)hasMoreData;
@end


#endif
