//
//  Dictionary.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/15.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_Dictionary_h
#define YANSIS_Dictionary_h

#import<Foundation/Foundation.h>
#import"FileAccessor.h"
#import"DataAccessor.h"
#import"DoubleArrayTrie.h"
#import"CToken.h"

@interface Dictionary : NSObject
-(id)init;
-(id)initWithFile:(NSString *)tokenFile doubleArrayFile:(NSString *)doubleArrayFile posInfoFile:(NSString *)posInfoFile charset:(NSStringEncoding)_charset;
-(NSArray *)commonPrefixSearch:(NSString *)str position:(int)pos;
-(NSArray *)exactMatchSearch:(NSString *)str position:(int)pos;
-(NSString *)getPosInfo:(int)f;
-(CToken *)getBOSToken;
-(CToken *)getEOSToken;
-(CToken *)getUnknownToken;

@end

#endif
