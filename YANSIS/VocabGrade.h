//
//  VocabGrade.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/15.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_VocabGrade_h
#define YANSIS_VocabGrade_h

#import<Foundation/Foundation.h>
#import"POS.h"
#import"Token.h"
#import"CSVAnalyzer.h"
#import"StringAccessor.h"

@interface VocabGradeItem : NSObject
@property(nonatomic) NSString *word;
@property(nonatomic) NSString *yomi;
@property(nonatomic) POS *pos;
@property(nonatomic) int grade;
@property(nonatomic) int num_word;
-(id)initWithWord:(NSString *)word yomi:(NSString *)yomi grade:(int)grade pos:(NSString *)pos numWord:(int)num_word;
-(Boolean)matchOne:(Token *)inword;
@end

@interface VocabHash : NSObject
-(id)init;
-(void)put:(NSString *)key vocabGradeItem:(VocabGradeItem *)value;
-(NSMutableArray *)get:(NSString *)key;
@end

@interface VocabGrade : NSObject
-(id)initWithString:(NSString *)filename;
+(NSString *)concat:(NSArray *)toks index:(int)ind n:(int)n;
+(NSString *)concatSurface:(NSArray *)toks index:(int)ind n:(int)n;
+(NSString *)concatPronunciation:(NSArray *)toks index:(int)ind n:(int)n;
+(NSString *)concatReading:(NSArray *)toks index:(int)ind n:(int)n;
-(int)matchMulti:(NSArray *)toks index:(int)ind;
-(int)matchOne:(NSArray *)toks index:(int)ind;
@end
#endif
