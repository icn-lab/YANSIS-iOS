//
//  CompositPostProcessor.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "CompositPostProcessor.h"

const int BUFSIZE = 1024;

@implementation CompositPostProcessor{
    NSArray *rules;
}

-(id)init{
    if(self = [super init]){
        rules = nil;
    }
    return self;
}

-(void)readRules:(StringAccessor *)sfa{
    
    NSMutableArray *__rules = [[NSMutableArray alloc] init];
    while([sfa hasMoreData]){
        NSString *line = [sfa readLine];
        NSArray *sta = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n "]];
        NSMutableArray *st = [[NSMutableArray alloc] initWithArray:sta];
        if([st count] != 1)
            continue;
        
        NSMutableArray *ruleSet = [[NSMutableArray alloc] init];
        NSString *first = [[NSString alloc] initWithString:st[0]];
        if([st count] == 1){
            [self removeFromOtherRules:first];
            [ruleSet addObject:first];
            [__rules addObject:[[Rule alloc] initWithString:first ruleSet:ruleSet]];
            continue;
        }
        while([st count] > 1){
            NSString *pos = st[0];
            [st removeObjectAtIndex:0];
            [self removeFromOtherRules:pos];
            [ruleSet addObject:pos];
        }
        [__rules addObject:[[Rule alloc] initWithString:first ruleSet:ruleSet]];
    }
    
    rules = [[NSMutableArray alloc] initWithArray:__rules];
}

-(void)removeFromOtherRules:(NSString *)pos{
    for(Rule *rule in rules){
        if([rule contains:pos]){
            [rule remove:pos];
            return;
        }
    }
}

-(NSArray *)List{
    return rules;
}

-(NSArray *)getRules{
    return rules;
}

-(NSArray *)process:(NSArray *)tokens postProcessInfo:(NSMutableDictionary *)postProcessInfo{
    if([tokens count] == 0){
        return tokens;
    }
    
    NSMutableArray *newTokens = [[NSMutableArray alloc] init];
    Token *prevToken = nil;
    Rule *currentRule = nil;
    
    for(int i=0;i < [tokens count];i++){
        if(currentRule != nil){
            if((prevToken != nil && ([prevToken end] != [tokens[i] _start]))
               || ![currentRule contains:[tokens[i] getPos]]){
                currentRule = nil;
                [newTokens addObject:prevToken];
                prevToken = nil;
            }
            else{
                [self merge:prevToken current:tokens[i] newPos:[currentRule getPos]];
                if(i == [tokens count]-1){
                    [newTokens addObject:prevToken];
                    prevToken = nil;
                }
                continue;
            }
                
        }
        Boolean outer_loop = false;
        for(Rule *rule in rules){
            if([rule contains:[tokens[i] getPos]]){
                currentRule = rule;
                prevToken   = tokens[i];
                outer_loop = true;
                break;
            }
        }
        if(outer_loop)
            continue;
        
        currentRule = nil;
        [newTokens addObject:tokens[i]];
    }
    if(prevToken != nil){
        [newTokens addObject:prevToken];
    }
   
    return [NSArray arrayWithArray:newTokens];
}

-(void)merge:(Token *)prev current:(Token *)current newPos:(NSString *)newPos{
    if(prev == nil){
        return;
    }
    
    [prev setBasicString:[[prev getBasicString] stringByAppendingString:[current getBasicString]]];
    [prev setCost:[prev getCost]+[current getCost]];
    [prev setPos:newPos];
    [prev setPronunciation:[[prev getPronunciation] stringByAppendingString:[current getPronunciation]]];
    [prev setReading:[[prev getReading] stringByAppendingString:[current getReading]]];
    [prev setLength:[prev length]+[current length]];
    [prev setSurface:nil];
}
@end

@implementation Rule {
    NSString *_pos;
    NSMutableArray *_ruleSet;
}

-(id)initWithString:(NSString *)pos ruleSet:(NSArray *)ruleSet{
    if(self = [super init]){
        _pos = pos;
        _ruleSet = [[NSMutableArray alloc] initWithArray:ruleSet];
    }

    return self;
}

-(NSString *)getPos{
    return _pos;
}

-(Boolean) contains:(NSString *)pos{
    Boolean find = false;
    for(NSString *rule in _ruleSet){
        if([rule compare:pos] == NSOrderedSame){
            find = true;
            break;
        }
    }
    
    return find;
}

-(void)remove:(NSString *)pos{
    for(NSString *rule in _ruleSet){
        if([rule compare:pos] == NSOrderedSame){
            [_ruleSet removeObject:rule];
            break;
        }
    }
}

-(NSString *)toString{
    NSMutableString *buf = [[NSMutableString alloc] init];
    for(NSString *rule in _ruleSet){
        [buf appendFormat:@" %@",rule];
    }
    
    return [NSString stringWithString:buf];
}

@end