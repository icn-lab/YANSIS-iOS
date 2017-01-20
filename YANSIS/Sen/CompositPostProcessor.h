//
//  CompositPostProcessor.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_CompositPostProcessor_h
#define YANSIS_CompositPostProcessor_h

#import<Foundation/Foundation.h>
#import"PostProcessor.h"
#import"Token.h"
#import"StringAccessor.h"

@interface CompositPostProcessor : PostProcessor
-(void)readRules:(StringAccessor *)sfa;
-(void)removeFromOtherRules:(NSString *)pos;
-(NSMutableArray *)getRules;
-(NSMutableArray *)process:(NSMutableArray *)tokens postProcessInfo:(NSMutableDictionary *)postProcessInfo;
-(void)merge:(Token *)prev current:(Token *)current newPos:(NSString *)newPos;
@end

@interface Rule : NSObject
-(id)initWithString:(NSString *)pos ruleSet:(NSArray *)ruleSet;
-(NSString *)getPos;
-(Boolean)contains:(NSString *)pos;
-(void)remove:(NSString *)pos;
-(NSString *)toString;
@end
#endif
