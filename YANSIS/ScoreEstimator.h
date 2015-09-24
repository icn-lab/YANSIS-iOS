//
//  ScoreEstimator.h
//  YANSIS
//
//  Created by 長野雄 on 2015/04/13.
//  Copyright (c) 2015年 長野雄. All rights reserved.
//

#ifndef YANSIS_ScoreEstimator_h
#define YANSIS_ScoreEstimator_h

#import<Foundation/Foundation.h>
#import"WordProperty.h"
#import"StringAccessor.h"

static const int NDIM = 25;

@interface ScoreEstimator : NSObject
@property(nonatomic) NSArray  *weight;
@property(nonatomic) NSString *setKANJI;
@property(nonatomic) NSString *setHIRAGANA;
@property(nonatomic) NSString *setKATAKANA;

-(id)initWithFile:(NSString *)filename;
-(void)readWeight:(NSString *)filename;
-(double)calcScore:(NSArray *)vector;
-(double)estimateScore:(NSArray *)s;
-(void)printVector:(NSArray *)vector;
-(NSArray *)calcFeatureVector:(NSArray *)s;
-(int)getCharacterCount:(WordProperty *)w;
-(int)getCharacterCountInSentence:(NSArray *)s;
-(int)getWordCount:(NSArray *)s;
-(Boolean)isNoun:(WordProperty *)w;
-(int)getNounCountInSentence:(NSArray *)s;
-(Boolean)isVerb:(WordProperty *)w;
-(int)getVerbCount:(NSArray *)s;
-(double)getAverageLevel:(NSArray *)s;
-(int)getLevelNWordCount:(NSArray *)w level:(int)level;
-(Boolean)isLoanWord:(WordProperty *)w;
-(int)getLoanWordCount:(NSArray *)s;
-(int)getKanjiCount:(WordProperty *)w;
-(int)getKanjiCountInSentence:(NSArray *)s;
-(int)getHiraganaCount:(WordProperty *)w;
-(int)getHiraganaCountInSentence:(NSArray *)s;
-(int)getKatakanaCount:(WordProperty *)w;
-(int)getKatakanaCountInSentence:(NSArray *)s;
@end
#endif
