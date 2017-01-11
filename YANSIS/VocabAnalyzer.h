//
//  VocabAnalyzer.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/19.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_VocabAnalyzer_h
#define YANSIS_VocabAnalyzer_h

#import <Foundation/Foundation.h>
#import "Token.h"
#import "VocabGrade.h"
#import "GradeTable.h"
#import "WordWithGrade.h"

@interface VocabAnalyzer : NSObject
@property(nonatomic) NSArray *grade;

-(id)initWithGradeTable:(NSArray *)table;
-(NSMutableArray *)analyze:(NSArray *)toks;
@end
#endif
