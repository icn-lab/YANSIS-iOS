//
//  JapaneseTokenizer.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/17.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_JapaneseTokenizer_h
#define YANSIS_JapaneseTokenizer_h

#import<Foundation/Foundation.h>
#import"CToken.h"
#import"Node.h"
#import"Tokenizer.h"

@interface JapaneseTokenizer : Tokenizer
extern const int OTHER;
extern const int SPACE;
extern const int KANJI;
extern const int KATAKANA;
extern const int HIRAGANA;
extern const int HALF_WIDTH;

-(id)initWithFiles:(NSString *)tokenFile doubleArrayFile:(NSString *)doubleArrayFile posInfoFile:(NSString *)posInfoFile connectFile:(NSString *)connectFile charset:(NSStringEncoding)charset;
-(int)getCharClass:(unichar)c;
-(Node *)lookup:(NSString *)s begin:(int)begin;
@end
#endif
