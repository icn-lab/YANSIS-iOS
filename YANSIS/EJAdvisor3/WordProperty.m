//
//  WordProperty.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/19.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "WordProperty.h"

@implementation WordProperty{
    WordWithGrade *wgrade;
}

-(id)initWithWordWithGrade:(WordWithGrade *)wg{
    if(self = [super init]){
        wgrade = wg;
    }
    return self;
}

-(Boolean)is_easy{
    return ((wgrade.grade >= 3) || [self is_proper_noun] || [self is_digits]);
}

-(Boolean)is_difficult{
    if([self is_proper_noun]||[self is_digits])
        return false;
    return wgrade.grade == 1 || wgrade.grade == 2;
}

-(Boolean)is_verydifficult{
    if([self is_proper_noun] || [self is_digits])
        return false;
    return wgrade.grade == 0;
}

-(Boolean)is_conjugate{
    return wgrade.cform != nil;
}

-(Boolean)is_digits{
    NSString *s = wgrade.word;
    NSRange match = [s rangeOfString:@"^[0-9]+$" options:NSRegularExpressionSearch];
    if(match.location == NSNotFound){
        return false;
    }
    return true;
}

-(Boolean)is_content_word{
    NSString *pos = [self getPOS];
    NSArray *posElem = [pos componentsSeparatedByString:@"-"];
//    NSLog(@"posElem:%@", posElem[0]);
    if([posElem[0] compare:@"名詞"] == NSOrderedSame|| [posElem[0] compare:@"動詞"] == NSOrderedSame||
       [posElem[0] compare:@"形容詞"] == NSOrderedSame || [posElem[0] compare:@"副詞"] == NSOrderedSame||
       [posElem[0] compare:@"連体詞"] == NSOrderedSame || [posElem[0] compare:@"接続詞"] == NSOrderedSame){
//        NSLog(@"step1");
        if([posElem count] > 1 &&
           ([posElem[1] compare:@"非自立"] == NSOrderedSame ||
            [posElem[1] compare:@"接尾"] == NSOrderedSame)){
 //              NSLog(@"poselem:%@", posElem[1]);
            return false;
           }
        else
            return true;
    }
    return false;
}

-(Boolean)is_proper_noun{
    NSString *pos = [self getPOS];
    return [pos hasPrefix:@"名詞-固有名詞"];
}

-(NSString *)toString{
    return wgrade.word;
}

-(NSString *)getBasicString{
    return wgrade.basicString;
}

-(NSString *)getPOS{
    return wgrade.pos;
}

-(int)getGrade{
    return wgrade.grade;
}

-(NSString *)getReading{
    return wgrade.reading;
}

-(NSString *)getPronunciation{
    return wgrade.pronunciation;
}

-(NSString *)getCform{
    return wgrade.cform;
}

-(int)pronunciationLength{
    int n = 0;
    if([wgrade.pos hasPrefix:@"記号"]){
        return 0;
    }
    if(wgrade.pronunciation == nil){
        return (int)[wgrade.word length];
    }
    for(int i=0;i < [wgrade.pronunciation length];i++){
        unichar c = [wgrade.pronunciation characterAtIndex:i];
        if(c != L'ァ' && c != L'ィ' && c != L'ゥ' && c != L'ェ' && c != L'ォ' &&
           c != L'ャ' && c != L'ュ' && c != L'ョ')
            n++;
    }

    return n;
}





@end