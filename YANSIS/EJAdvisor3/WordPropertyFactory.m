//
//  WordPropertyFactory.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/22.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "WordPropertyFactory.h"

@implementation WordPropertyFactory{
    StringTagger *tagger;
    VocabAnalyzer *va;
    NSArray *toks;
}

-(id)initWithConfig:(EJConfig *)conf{
    if(self = [super init]){
        //tagger = [[StringTagger alloc] initWithConfig:conf.sen_conf path:conf.sen_dir];
        va = [[VocabAnalyzer alloc] initWithGradeTable:conf.grade];
    }

    return self;
}

-(NSArray *)analyzeFromFeature:(NSArray *)feature{
    NSMutableArray *mtoks = [[NSMutableArray alloc] init];
    
    NSLog(@"WPF:analyzeFromFeature");

    for(int i=0;i < feature.count;i++){
        MToken *mt = [[MToken alloc] init];
        [mt setFeature:feature[i]];
        [mtoks addObject:mt];
        /*
        NSLog(@"pos:%@\n", [mt getPos]);
        NSLog(@"pronunciation:%@\n", [mt getPronunciation]);
        NSLog(@"basic:%@\n", [mt getBasicString]);
        NSLog(@"cform:%@\n", [mt getCform]);
        NSLog(@"read:%@\n", [mt getReading]);
        NSLog(@"terminfo:%@\n", [mt getTermInfo]);
        NSLog(@"addinfo:%@\n", [mt getAddInfo]);
        NSLog(@"node_surface:%@\n", [mt getSurface]);
        */
    }
    
    NSArray *res  = [va analyze:[NSArray arrayWithArray:mtoks]];
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
    NSLog(@"WPF:analyzeFromFeature done");
    return [NSArray arrayWithArray:val];
}


-(NSArray *)analyzeText:(NSString *)text{
    @autoreleasepool {
        NSLog(@"WPF:analyzeText");
        toks = [tagger analyze:text];
        NSLog(@"toks:%d", (int)[toks count]);
        for(int i=0;i < toks.count;i++){
            NSLog(@"pos:%@\n", [toks[i] getPos]);
            NSLog(@"pronunciation:%@\n", [toks[i] getPronunciation]);
            NSLog(@"basic:%@\n", [toks[i] getBasicString]);
            NSLog(@"cform:%@\n", [toks[i] getCform]);
            NSLog(@"read:%@\n", [toks[i] getReading]);
            NSLog(@"terminfo:%@\n", [toks[i] getTermInfo]);
            NSLog(@"addinfo:%@\n", [toks[i] getAddInfo]);
            NSLog(@"node_surface:%@\n", [toks[i] getSurface]);
        }
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

-(NSArray *)getToken{
    return toks;
}

@end
