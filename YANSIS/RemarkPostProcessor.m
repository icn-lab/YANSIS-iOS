//
//  RemarkPostProcessor.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/17.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "RemarkPostProcessor.h"

@implementation RemarkPostProcessor
-(NSArray *)process:(NSArray *)tokens postProcessInfo:(NSDictionary *)postProcessInfo{
    NSArray *tokenList = [postProcessInfo valueForKey:@"remark"];
    if([tokenList count] == 0){
        return tokens;
    }
   
    NSArray *retTokens;
    if([tokens count] == 0){
        retTokens = [NSArray arrayWithArray:tokenList];
        return retTokens;
    }

    NSMutableArray *newTokens = [[NSMutableArray alloc] initWithCapacity:[tokens count]+[tokenList count]];
    
    int itr = 0;
    Token *addToken = tokenList[itr++];
    int newTokenCount = 0;
    
    for(Token *token in tokens){
        while(addToken != nil && [token _start] >= [addToken _start]){
            newTokens[newTokenCount++] = addToken;
            if(itr == [tokenList count]-1){
                addToken = nil;
                break;
            }
            if(itr < [tokenList count])
                addToken = tokenList[itr++];
        }
        newTokens[newTokenCount++] = token;
    }
    if(addToken != nil){
        newTokens[newTokenCount++] = addToken;
        while(itr < [tokenList count]){
            newTokens[newTokenCount++] = tokenList[itr++];
        }
    }

    retTokens = [NSArray arrayWithArray:newTokens];
    return retTokens;
}
@end

