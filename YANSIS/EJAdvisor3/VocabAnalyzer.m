//
//  VocabAnalyzer.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/19.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "VocabAnalyzer.h"

@implementation VocabAnalyzer

-(id)initWithGradeTable:(NSArray *)table{
    if(self = [super init]){
        self.grade = table;
    }
    return self;
}

-(NSMutableArray *)analyze:(NSArray *)toks{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    int i = 0;
    int m;
    while(toks != nil && i < [toks count]){
        m = 0;
        for(GradeTable *gt in self.grade){
            m = [gt matchMulti:toks index:i];
            if(m > 0){
                [result addObject:[[WordWithGrade alloc] initWithParameters:[VocabGrade concatSurface:toks index:i n:m] basicString:[VocabGrade concat:toks index:i n:m] reading:[VocabGrade concatReading:toks index:i n:m] pronunciation:[VocabGrade concatPronunciation:toks index:i n:m] pos:[toks[i+m-1] getPos] cform:[toks[i+m-1] getCform] grade:gt.grade ]];
                i+=m;
                break;
            }
        }
        if(m > 0)
            continue;
        
        for(GradeTable *gt in self.grade){
            m = [gt matchOne:toks index:i  ];
            if(m > 0){
                [result addObject:[[WordWithGrade alloc] initWithToken:toks[i] grade:gt.grade]];
                 i++;
                break;
            }
        }
        if(m > 0)
            continue;
        
        [result addObject:[[WordWithGrade alloc] initWithToken:toks[i] grade:0]];
        i++;
    }
    
    return result;
}

@end
