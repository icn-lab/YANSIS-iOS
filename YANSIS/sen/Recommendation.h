//
//  Recommendation.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/22.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_Recommendation_h
#define YANSIS_Recommendation_h

#import<Foundation/Foundation.h>
#import "WordProperty.h"
#import "StringAccessor.h"

@interface Morpheme : NSObject
@property(nonatomic) NSString *surface;
@property(nonatomic) NSString *base;
@property(nonatomic) NSString *pos;
@property(nonatomic) NSString *cform;
-(id)initWithParameters:(NSString *)surface base:(NSString *)base pos:(NSString *)pos cform:(NSString *)cform;
-(Boolean)equals:(WordProperty *)w;
-(NSString *)toString;
@end

@interface RecommendationPattern : NSObject
@property(nonatomic) NSArray *morph;
@property(nonatomic) NSString       *advice;
-(id)initWithParameters:(NSArray *)morph advice:(NSString *)advice;
-(int)length;
-(Boolean)matchAt:(NSArray *)w pos:(int)pos;
-(NSString *)firstWord;
-(NSString *)getAdvice;
@end

@interface RecommendationHash : NSObject
@property(nonatomic) NSMutableDictionary *myhash;
-(id)init;
-(void)add:(RecommendationPattern *)pat;
-(NSArray *)getAdvices:(NSArray *)w pos:(int)pos;
@end

@interface Recommendation : NSObject
@property(nonatomic) RecommendationHash *h;
-(id)initWithFilename:(NSString *)filename encode:(NSStringEncoding)encode;
-(NSArray
  *)getRecommendations:(NSArray *)w;
@end

#endif