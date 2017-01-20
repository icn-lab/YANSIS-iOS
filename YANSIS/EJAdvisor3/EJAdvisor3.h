//
//  EjAdvisor3.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/24.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_EjAdvisor3_h
#define YANSIS_EjAdvisor3_h

#import<Foundation/Foundation.h>
#import"WordProperty.h"
#import"WordPropertyFactory.h"
#import"Recommendation.h"
#import"ExampleFinder.h"
#import"ScoreEstimator.h"

@interface EJAdvisor3 : NSObject
-(id)initWithString:(NSString *)baseDir;
-(void)initialize;
-(Boolean)isSentenceEnd:(WordProperty *)w;
-(NSArray *)splitSentence:(NSArray *)w;
-(NSString *)suppressString:(NSString *)s;
-(WordProperty *)currentMorph:(int)s i:(int)i;
-(NSArray *)doAnalysis:(NSString *)t;
-(NSArray *)doAnalysisFromFeature:(NSArray *)f;
-(double)estimateScore:(NSArray *)s;
-(NSArray *)getRecommendations:(NSArray *)s;
-(NSArray *)exampleSentence:(WordProperty *)w;
@end
#endif
