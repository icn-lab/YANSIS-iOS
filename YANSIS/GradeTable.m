//
//  GradeTable.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import"GradeTable.h"

@implementation GradeTable
-(id)initWithString:(NSString *)filename grade:(int)grade{
    if(self=[super initWithString:filename]){
        self.grade = grade;
    }
    return self;
}

@end