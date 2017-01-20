//
//  JapaneseTokenizer.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/17.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "JapaneseTokenizer.h"
const int OTHER = 0x80;
const int SPACE = 0x81;
const int KANJI = 0x82;
const int KATAKANA = 0x83;
const int HIRAGANA = 0x84;
const int HALF_WIDTH = 0x85;


@implementation JapaneseTokenizer{
    NSString *setKANJI;
    NSString *setKATAKANA;
    NSString *setHIRAGANA;
}

-(id)initWithFiles:(NSString *)tokenFile doubleArrayFile:(NSString *)doubleArrayFile posInfoFile:(NSString *)posInfoFile connectFile:(NSString *)connectFile charset:(NSStringEncoding)charset{
    if(self = [super initWithFiles:tokenFile doubleArrayFile:doubleArrayFile posInfoFile:posInfoFile connectFile:connectFile charset:charset]){
        setKANJI = @"[一-龠]";
        setKATAKANA = @"[ァ-ヶ]";
        setHIRAGANA = @"[ぁ-ん]";
    }
    
    return self;
}

-(int)getCharClass:(unichar)c{
    if(c == L' ' || c == L'\t' || c == L'\r' || c == '\n')
        return SPACE;
 
    NSString *str = [[NSString alloc] initWithCharacters:&c length:1];
   
    NSRange match = [str rangeOfString:setKANJI options:NSRegularExpressionSearch];
    if(match.location != NSNotFound)
        return KANJI;
    
    match = [str rangeOfString:setKATAKANA options:NSRegularExpressionSearch];
    if(match.location != NSNotFound)
        return KATAKANA;
    
    match = [str rangeOfString:setHIRAGANA options:NSRegularExpressionSearch];
    if(match.location != NSNotFound)
        return HIRAGANA;
    
    return OTHER;
}

-(Node *)lookup:(NSString *)s begin:(int)begin{
  //NSLog(@"s:%@", s);
    Node *resultNode = nil;
    int char_class = 0;
  
    int end = (int)[s length];
    
    int begin2 = [self skipCharClass:s begin:begin end:end char_class:char_class];
    if(begin2 == end){
        return nil;
    }
    
    NSArray *t = [self.dic commonPrefixSearch:s position:begin2];
    for(int i = 0;i < [t count];i++){
        if(t[i] == [NSNull null])
            break;
        CToken *token = t[i];
        Node *newNode = [self getNewNode];
        newNode.token = token;
        newNode.length = token.length;
        newNode.surface = s;
        newNode.begin = begin2;
        newNode.end   = begin2 - begin + token.length;
        newNode.rnext = resultNode;
        
        resultNode = newNode;
    }
    
    if((resultNode != nil)
       && (char_class == HIRAGANA || char_class == KANJI)){
        return resultNode;
    }
   
    int begin3;
    
    switch(char_class){
        case HIRAGANA:
        case KANJI:
        case OTHER:
            begin3 = begin2 + 1;
            break;
        default:
            begin3 = [self skipCharClass:s begin:begin2+1 end:end char_class:char_class];
            break;
    }
    //NSLog(@"begin3=%d",begin3);
    Node *newNode = [self getNewNode];
    newNode.token = self.unknownToken;
    newNode.surface = s;
    newNode.begin = begin2;
    newNode.length = begin3 - begin2;
    newNode.end = begin3 - begin;
    newNode.termInfo = nil;
    newNode.rnext = resultNode;
    //NSLog(@"newNode:%@", [newNode toString]);
    return newNode;
}

@end
