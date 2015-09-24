//
//  EJAdvisor3.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/24.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import"EJAdvisor3.h"

@implementation EJAdvisor3{
    WordPropertyFactory *analyzer;
    EJConfig *conf;
    Recommendation *recommend;
    NSArray *currentSent;
    NSString *_baseDir;
    ExampleFinder *examples;
    ScoreEstimator *scoreEstimator;
    NSArray *suppress;
}

-(id)initWithString:(NSString *)baseDir{
    if(self = [super init]){
        _baseDir = baseDir;
        [self initialize];
    }
    return self;
}

-(void)initialize{
    conf = [[EJConfig alloc] initWithDir:_baseDir n:6];
    conf.sen_conf  = @"conf/sen.xml";
    conf.sen_dir   = [NSString stringWithFormat:@"%@/sen", conf.basedir];
    conf.morph_dir = [NSString stringWithFormat:@"%@/morph", conf.basedir];
    conf.easyword       = [NSString stringWithFormat:@"%@/easyword.txt", conf.morph_dir];
    NSString *exfile    = [NSString stringWithFormat:@"%@/Examples.csv", conf.morph_dir];
    NSString *rcmdfile  = [NSString stringWithFormat:@"%@/GrammaticalRecommendation.csv", conf.morph_dir];
    NSString *weightFile = [NSString stringWithFormat:@"%@/score-foreign-all.w", conf.morph_dir];
    examples = [[ExampleFinder alloc] initWithString:exfile encode:NSShiftJISStringEncoding];
    [conf set_grade:@"vocabS.csv" n:6];
    [conf set_grade:@"vocabB.csv" n:5];
    [conf set_grade:@"vocab4.csv" n:4];
    [conf set_grade:@"vocab3.csv" n:3];
    [conf set_grade:@"vocab2.csv" n:2];
    [conf set_grade:@"vocab1.csv" n:1];
    analyzer = [[WordPropertyFactory alloc] initWithConfig:conf];
    recommend = [[Recommendation alloc] initWithFilename:rcmdfile encode:NSShiftJISStringEncoding];
    scoreEstimator = [[ScoreEstimator alloc] initWithFile:weightFile];
    suppress = [[NSArray alloc] initWithObjects:@"[　\\s\\n\\t]+", nil];
//    suppress = [[NSArray alloc] initWithObjects:@"　", @"\\s+", @"\\n", @"\\t", nil];
    
}

-(Boolean)isSentenceEnd:(WordProperty *)w{
    if([[w getPOS] compare:@"記号-句点"] == NSOrderedSame)
        return true;

    if([[w toString] compare:@"？"] == NSOrderedSame)
        return true;
    
    if([[w toString] compare:@"！"] == NSOrderedSame)
        return true;
    
    return false;
}

-(NSArray *)splitSentence:(NSArray *)w{
    NSLog(@"EJA:splitSentence");
    NSMutableArray *bpos = [[NSMutableArray alloc] init];
    [bpos addObject:[[NSNumber alloc] initWithInt:0]];
    
    for(int i=0;i < [w count];i++){
  //      NSLog(@"w:%@ %@", [w[i] toString], [w[i] getPOS]);
        if([self isSentenceEnd:w[i]] && i < [w count]-1){
            [bpos addObject:[[NSNumber alloc] initWithInt:i+1]];
        }
    }
    NSLog(@"EJA:step1 finished, bpos:%d", (int)[bpos count]);
    
    [bpos addObject:[NSNumber numberWithInt:(int)[w count]]];
    NSMutableArray *res = [[NSMutableArray alloc] initWithCapacity:[bpos count]-1];
    for(int i=1;i < [bpos count];i++){
        int n = (int)[bpos[i] integerValue] - (int)[bpos[i-1] integerValue];
        res[i-1] = [[NSMutableArray alloc] initWithCapacity:n];
        for(int j=0;j < n;j++){
            res[i-1][j] = w[[bpos[i-1] integerValue]+j];
        }
    }
    NSLog(@"EJA:splitSentence end, res=%d", (int)[res count]);
    return [NSArray arrayWithArray:res];
}

-(NSString *)suppressString:(NSString *)s{
    for(NSString *str in suppress){
        s = [s stringByReplacingOccurrencesOfString:str
                                        withString:@""
                                           options:NSRegularExpressionSearch
                                             range:NSMakeRange(0, [s length])];
    }
    
    return s;
}

-(WordProperty *)currentMorph:(int)s i:(int)i{
    return currentSent[s][i];
}

-(NSArray *)doAnalysis:(NSString *)t{
    t = [self suppressString:t];
    NSArray *w = [analyzer analyzeText:t];
    NSLog(@"analyzeText done");
    currentSent = [self splitSentence:w];
    NSLog(@"split sentence done");
    return currentSent;
}

-(double)estimateScore:(NSArray *)s{
    double score = [scoreEstimator estimateScore:s];
  //  NSLog(@"score:%.2f", score);
    score = score * 100.0 / 2.0;
    if(score > 100.0)
        score = 100.0;
    return score;
}

-(NSArray *)getRecommendations:(NSArray *)s{
    return [recommend getRecommendations:s];
}

-(NSArray *)exampleSentence:(WordProperty *)w{
    NSArray *res = [examples grepNJ:[w getBasicString]];
    
    return res;
}
@end
