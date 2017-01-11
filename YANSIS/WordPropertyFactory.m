//
//  WordPropertyFactory.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/22.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordPropertyFactory.h"

@implementation WordPropertyFactory{
    StringTagger *tagger;
    VocabAnalyzer *va;
}

-(id)initWithConfig:(EJConfig *)conf{
    if(self = [super init]){
        tagger = [[StringTagger alloc] initWithConfig:conf.sen_conf path:conf.sen_dir];
        va = [[VocabAnalyzer alloc] initWithGradeTable:conf.grade];
    }

    return self;
}

-(NSArray *)analyzeText:(NSString *)text{
    @autoreleasepool {
        NSLog(@"WPF:analyzeText");
        NSArray *toks = [tagger analyze:text];
        NSLog(@"toks:%d", (int)[toks count]);
        NSArray *res  = [va analyze:toks];
        NSLog(@"res:%d", (int)[res count]);
        NSMutableArray *val = [[NSMutableArray alloc] init];
        int cnt = 0;
        for(int i=0;i < [res count];i++){
            WordWithGrade *wg = res[i];
            if([wg.word compare:@"\n"] != NSOrderedSame){
                val[cnt++] = [[WordProperty alloc] initWithWordWithGrade:res[i]];
            }
            //NSLog(@"%@, %d", [ret_val[i] toString], [ret_val[i] getGrade]);
        }
        NSLog(@"WPF:analyzeText done");
        return [NSArray arrayWithArray:val];
    }
}

@end