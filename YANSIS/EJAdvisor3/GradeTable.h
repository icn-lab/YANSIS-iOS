//
//  GradeTable.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_GradeTable_h
#define YANSIS_GradeTable_h

#import<Foundation/Foundation.h>
#import"VocabGrade.h"

@interface GradeTable : VocabGrade
@property(nonatomic) int grade;
-(id)initWithString:(NSString *)filename grade:(int)grade;
@end
#endif
