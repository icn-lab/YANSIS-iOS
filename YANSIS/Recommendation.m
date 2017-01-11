//
//  Recommendation.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/22.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "Recommendation.h"

#define BUFSIZE 1024

@implementation Morpheme
-(id)initWithParameters:(NSString *)surface base:(NSString *)base pos:(NSString *)pos cform:(NSString *)cform{
    
    if(self = [super init]){
        self.surface = surface;
        self.base    = base;
        self.pos     = pos;
        self.cform   = cform;
    }
    
    return self;
}

-(Boolean)equals:(WordProperty *)w{
    if([self.surface compare:@"*"] != NSOrderedSame && [self.surface compare:[w toString]] != NSOrderedSame)
        return false;
    if([self.base compare:@"*"] != NSOrderedSame && [self.base compare:[w getBasicString]] != NSOrderedSame)
        return false;
    if([self.pos compare:@"*"] != NSOrderedSame && [self.pos compare:[w getPOS]] != NSOrderedSame)
        return false;
    if(self.cform != nil && [self.cform compare:@"*"] != NSOrderedSame && [self.cform compare:[w getCform]] != NSOrderedSame)
        return false;

    return true;
}

-(NSString *)toString{
    return [self.surface stringByAppendingFormat:@"/%@/%@", self.base, self.pos];
}
@end

@implementation RecommendationPattern
-(id)initWithParameters:(NSArray *)morph advice:(NSString *)advice{
    if(self = [super init]){
        self.morph = morph;
        self.advice = advice;
    }

    return self;
}

-(int)length{
    return (int)[self.morph count];
}

-(Boolean)matchAt:(NSMutableArray *)w pos:(int)pos{
    if(pos+[self length]-1 > [w count]-1)
        return false;
    for(int i=0;i < [self length];i++){
        if(![self.morph[i] equals:w[i+pos]])
             return false;
    }
    
    return true;
}

-(NSString *)firstWord{
    Morpheme *retVal = self.morph[0];
    return retVal.surface;
}

-(NSString *)getAdvice{
    return self.advice;
}
@end


@implementation RecommendationHash
-(id)init{
    if(self = [super init]){
        self.myhash = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)add:(RecommendationPattern *)pat{
    NSMutableArray *v = [self.myhash objectForKey:[pat firstWord]];
    if(v == nil){
        v = [[NSMutableArray alloc] init];
        [self.myhash setObject:v forKey:[pat firstWord]];
    }
    
    [v addObject:pat];
}

-(NSMutableArray *)getAdvices:(NSArray *)w pos:(int)pos{
    NSMutableArray *adv = [[NSMutableArray alloc] init];
    NSArray *v = [self.myhash objectForKey:[w[pos] toString]];
    
    if(v != nil){
        for(RecommendationPattern *pat in v){
            if([pat matchAt:w pos:pos]){
                [adv addObject:[pat getAdvice]];
            }
        }
    }
    
    v = [self.myhash objectForKey:@"*"];
    if(v != nil){
        for(RecommendationPattern *pat in v){
            if([pat matchAt:w pos:pos]){
                [adv addObject:[pat getAdvice]];
            }
        }
    }
    
    return adv;
}
@end

@implementation Recommendation
-(id)initWithFilename:(NSString *)filename encode:(NSStringEncoding)encode{
    if(self = [super init]){
        self.h = [[RecommendationHash alloc] init];
        StringAccessor *sfa = [[StringAccessor alloc] initWithFile:filename encoding:encode];
        int nline = 0;
        while([sfa hasMoreData]){
            NSString *line = [sfa readLine];
            nline++;
            
            line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if([line hasPrefix:@"#"] || [line length] == 0){
                continue;
            }
            NSArray *morphStr = [line componentsSeparatedByString:@","];
            int morphlen = (int)[morphStr count]-1;
            while(morphlen > 0 && [morphStr[morphlen] length] == 0)
                morphlen--;
            if(morphlen == 0)
                continue;
            NSMutableArray *morphs = [[NSMutableArray alloc] init];
            for(int i=0;i < morphlen;i++){
                NSArray *m = [morphStr[i] componentsSeparatedByString:@"/"];
                if([m count] < 3){
                    NSLog(@"Error in Recommendation!!");
                    exit(1);
                }
                NSString *cform;
                if([m count] > 3)
                    cform = m[3];
                morphs[i] = [[Morpheme alloc] initWithParameters:m[0] base:m[1] pos:m[2] cform:cform];
            }
            [self.h add:[[RecommendationPattern alloc] initWithParameters:morphs advice:morphStr[morphlen]]];
        }
    }
    return self;
}

-(NSArray *)getRecommendations:(NSArray *)w{
    NSMutableArray *res = [[NSMutableArray alloc]init];
    
    int yomiLength = 0;
    for(WordProperty *wp in w){
        yomiLength += [wp pronunciationLength];
        //NSLog(@"len: %d, [%@]", [wp pronunciationLength], [wp getPronunciation]);
    }
    if(yomiLength >= 40){
        NSString *message = [NSString stringWithFormat:@"文が長過ぎます(%d拍)。文を分割してください。", yomiLength];
        [res addObject:message];
    }
    else if (yomiLength >= 30){
        NSString *message = [NSString stringWithFormat:@"文がやや長いので(%d拍)、文の分割を検討してください。", yomiLength];
        [res addObject:message];
    }
    
    for(int i = 0;i < [w count];i++){
        NSArray *adv = [self.h getAdvices:w pos:i];
        for(NSString *str in adv)
            if(![res containsObject:str])
                [res addObject:str];
    }
    
    return [NSMutableArray arrayWithArray:res];
}
@end