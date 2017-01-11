//
//  WordProperty.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/19.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_WordProperty_h
#define YANSIS_WordProperty_h

#import<Foundation/Foundation.h>
#import"WordWithGrade.h"

@interface WordProperty : NSObject
-(id)initWithWordWithGrade:(WordWithGrade *)wg;
-(Boolean)is_easy;
-(Boolean)is_difficult;
-(Boolean)is_verydifficult;
-(Boolean)is_conjugate;
-(Boolean)is_digits;
-(Boolean)is_content_word;
-(Boolean)is_proper_noun;
-(NSString *)toString;
-(NSString *)getBasicString;
-(NSString *)getPOS;
-(int)getGrade;
-(NSString *)getReading;
-(NSString *)getPronunciation;
-(NSString *)getCform;
-(int)pronunciationLength;
@end
#endif
