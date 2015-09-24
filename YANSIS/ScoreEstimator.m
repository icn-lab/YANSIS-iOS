//
//  ScoreEstimator.m
//  YANSIS
//
//  Created by 長野雄 on 2015/04/13.
//  Copyright (c) 2015年 長野雄. All rights reserved.
//

#import "ScoreEstimator.h"

@implementation ScoreEstimator
-(id)initWithFile:(NSString *)filename{
    if(self = [super init]){
        [self readWeight:filename];
        self.setKANJI = @"[一-龠]";
        self.setKATAKANA = @"[ァ-ヶ]";
        self.setHIRAGANA = @"[ぁ-ん]";
    }
    return self;
}

-(void)readWeight:(NSString *)filename{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    StringAccessor *sfa = [[StringAccessor alloc] initWithFile:filename];
    
    NSString *line;
    while((line = sfa.readLine) != nil){
        [array addObject:[[NSNumber alloc] initWithDouble:[line doubleValue]]];
    }
    
    self.weight = [[NSArray alloc] initWithArray:array];
}

-(double)calcScore:(NSArray *)vector{
    double score = [self.weight[0] doubleValue];
    
    for(int i=0;i < NDIM;i++){
        double w = [self.weight[i+1] doubleValue];
        double v = [vector[i] doubleValue];
        score += w * v;
    }
    return score;
}

-(double)estimateScore:(NSArray *)s{
    NSArray *vector = [self calcFeatureVector:s];
    //[self printVector:vector];
    double score = [self calcScore:vector];
    
    return score;
}

-(void)printVector:(NSArray *)vector{
    for(int i=0;i < [vector count];i++){
        NSLog(@"vec[%d]=%.3f¥n", i, [vector[i] doubleValue]);
    }
}

-(NSArray *)calcFeatureVector:(NSArray *)s{
    NSMutableArray *vector = [[NSMutableArray alloc] init];
    
    int characeterCount = [self getCharacterCountInSentence:s];
    [vector addObject:[[NSNumber alloc] initWithInt:characeterCount]];

    int wordCount = [self getWordCount:s];
    [vector addObject:[[NSNumber alloc] initWithInt:wordCount]];

    int nounCount = [self getNounCountInSentence:s];
    [vector addObject:[[NSNumber alloc] initWithInt:nounCount]];
    
    double nounPercent = (double)nounCount / (double)wordCount;
    [vector addObject:[[NSNumber alloc] initWithDouble:nounPercent]];
    
    int verbCount = [self getVerbCount:s];
    [vector addObject:[[NSNumber alloc] initWithInt:verbCount]];
    
    double verbPercent = (double)verbCount / (double)wordCount;
    [vector addObject:[[NSNumber alloc] initWithDouble:verbPercent]];
    
    double averageLevel = [self getAverageLevel:s];
    [vector addObject:[[NSNumber alloc] initWithDouble:averageLevel]];
    
    int count[5];
    double countPercent[5];
    for(int i=0;i < 5;i++){
        count[i] = [self getLevelNWordCount:s level:i];
        [vector addObject:[[NSNumber alloc] initWithInt:count[i]]];
        
        countPercent[i] = (double)count[i] / (double)wordCount;
        [vector addObject:[[NSNumber alloc] initWithDouble:countPercent[i]]];
    }
    
    int loanWordCount = [self getLoanWordCount:s];
    [vector addObject:[[NSNumber alloc] initWithInt:loanWordCount]];
    double loanWordPercent = (double)loanWordCount / (double)wordCount;
    [vector addObject:[[NSNumber alloc] initWithDouble:loanWordPercent]];
    
    int kanjiCount = [self getKanjiCountInSentence:s];
    [vector addObject:[[NSNumber alloc] initWithInt:kanjiCount]];

    double kanjiPercent = (double)kanjiCount / (double)characeterCount;
    [vector addObject:[[NSNumber alloc] initWithDouble:kanjiPercent]];
    
    int hiraganaCount = [self getHiraganaCountInSentence:s];
    [vector addObject:[[NSNumber alloc] initWithInt:hiraganaCount]];

    double hiraganaPercent = (double)hiraganaCount / (double)characeterCount;
    [vector addObject:[[NSNumber alloc] initWithDouble:hiraganaPercent]];
    
    int katakanaCount = [self getKatakanaCountInSentence:s];
    [vector addObject:[[NSNumber alloc] initWithInt:katakanaCount]];

    double katakanaPercent = (double)katakanaCount / (double)characeterCount;
    [vector addObject:[[NSNumber alloc] initWithDouble:katakanaPercent]];
    
    return [NSArray arrayWithArray:vector];
}

-(int)getCharacterCount:(WordProperty *)w{
    if([[w getPOS] hasPrefix:@"記号"]){
        return 0;
    }
    NSString *str = [w toString];
    int length = (int)[str length];

    return length;
}

-(int)getCharacterCountInSentence:(NSArray *)s{
    int count = 0;
    for(int i=0;i < [s count];i++){
        count += [self getCharacterCount:s[i]];
    }
    return count;
}

-(int)getWordCount:(NSArray *)s{
    int count = 0;
    for(int i=0;i < [s count];i++){
        if([[s[i] getPOS] hasPrefix:@"記号"]){
            continue;
        }
        count += 1;
    }
    
    return count;
}

-(Boolean)isNoun:(WordProperty *)w{
    if([[w getPOS] hasPrefix:@"名詞"]){
        return true;
    }
    else{
        return false;
    }
}

-(int)getNounCountInSentence:(NSArray *)s{
    int count = 0;
    
    for(int i=0;i < [s count];i++){
        if([self isNoun:s[i]]){
            count++;
        }
    }
    
    return count;
}

-(Boolean)isVerb:(WordProperty *)w{
    if([[w getPOS] hasPrefix:@"動詞"]){
        return true;
    }
    else{
        return false;
    }
}

-(int)getVerbCount:(NSArray *)s{
    int count = 0;
    
    for(int i=0;i < [s count];i++){
        if([self isVerb:s[i]]){
            count++;
        }
    }
    
    return count;
}

-(double)getAverageLevel:(NSArray *)s{
    int count[5];
    int sum = 0;
    int total = 0;
    
    for(int i=0;i < 5;i++){
        count[i] = [self getLevelNWordCount:s level:i];
        sum += i * count[i];
        total += count[i];
    }
    
    return (double)sum / (double)total;
}

-(int)getLevelNWordCount:(NSArray *)w level:(int)level{
    int count = 0;
    
    for(int i=0;i < [w count];i++){
        if([w[i] getGrade] == level){
            count++;
        }
    }
    
    return count;
}

-(Boolean)isLoanWord:(WordProperty *)w{
    NSRange match = [[w toString] rangeOfString:self.setKATAKANA options:NSRegularExpressionSearch];

    if(match.location != NSNotFound)
        return true;
    else
        return false;

}

-(int)getLoanWordCount:(NSArray *)s{
    int count = 0;
    
    for(int i=0;i < [s count];i++){
        if([self isLoanWord:s[i]]){
            count++;
        }
    }
    
    return count;
}

-(int)getKanjiCount:(WordProperty *)w{
    NSString *str = [w toString];
    int count = 0;
    
    for(int i=0;i < [str length];i++){
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [str substringWithRange:range];
        //NSLog(@"substr:%@", subStr);
        NSRange match = [subStr rangeOfString:self.setKANJI options:NSRegularExpressionSearch];
        
        if(match.location != NSNotFound){
            count++;
            //NSLog(@"count:%d", count);
        }
    }
    
    return count;
}

-(int)getKanjiCountInSentence:(NSArray *)s{
    int count = 0;
    for(int i=0;i < [s count];i++){
        count += [self getKanjiCount:s[i]];
    }
    return count;
}

-(int)getHiraganaCount:(WordProperty *)w{
    NSString *str = [w toString];
    int count = 0;
    
    for(int i=0;i < [str length];i++){
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [str substringWithRange:range];
        NSRange match = [subStr rangeOfString:self.setHIRAGANA options:NSRegularExpressionSearch];
        
        if(match.location != NSNotFound){
            count++;
        }
    }
    
    return count;
}

-(int)getHiraganaCountInSentence:(NSArray *)s{
    int count = 0;
    for(int i=0;i < [s count];i++){
        count += [self getHiraganaCount:s[i]];
    }
    return count;
}

-(int)getKatakanaCount:(WordProperty *)w{
    NSString *str = [w toString];
    int count = 0;
    
    for(int i=0;i < [str length];i++){
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [str substringWithRange:range];
        NSRange match = [subStr rangeOfString:self.setKATAKANA options:NSRegularExpressionSearch];
        
        if(match.location != NSNotFound){
            count++;
        }
    }
    
    return count;
}

-(int)getKatakanaCountInSentence:(NSArray *)s{
    int count = 0;
    for(int i=0;i < [s count];i++){
        count += [self getKatakanaCount:s[i]];
    }
    
    return count;
}


@end