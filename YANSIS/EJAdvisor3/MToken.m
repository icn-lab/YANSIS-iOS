//
//  MToken.m
//  YANSIS
//
//  Created by 長野雄 on 2017/01/20.
//  Copyright © 2017年 長野雄. All rights reserved.
//

#import "MToken.h"

@implementation MToken{
    NSString *pos;
    NSString *pronunciation;
    NSString *basic;
    NSString *cform;
    NSString *read;
    NSString *nodeStr;
    NSString *termInfo;
    NSString *addInfo;
    
    NSString *feature;
    NSArray *termInfoArray;
}

-(id)init{
    if(self = [super init]){
        pos = nil;
        pronunciation = nil;
        basic    = nil;
        cform    = nil;
        read     = nil;
        nodeStr  = nil;
        termInfo = nil;
        addInfo  = nil;
        termInfoArray = nil;
    }
    
    return self;
}

-(void)setFeature:(NSString *)f{
    feature = f;
}

-(NSString *)getPos{
    if(pos == nil){
        NSString *pos1 = [self getField:1];
        NSString *pos2 = [self getField:2];
        NSString *pos3 = [self getField:3];
        NSString *pos4 = [self getField:4];
        
        pos = pos1;
        if(![pos2 isEqualToString:@"*"]){
            pos = [NSString stringWithFormat:@"%@-%@", pos, pos2];
            
            if(![pos3 isEqualToString:@"*"]){
                pos = [NSString stringWithFormat:@"%@-%@", pos, pos3];
                
                if(![pos3 isEqualToString:@"*"]){
                    pos = [NSString stringWithFormat:@"%@-%@", pos, pos4];
                }
            }
        }
    }
    
    return pos;
}

-(NSString *)getPronunciation{
    if(pronunciation == nil)
        pronunciation = [self getField:9];
    
    return pronunciation;
}

-(NSString *)getBasicString{
    if(basic == nil)
        basic = [self getField:7];
    
    return basic;
}

-(NSString *)getCform{
    if(cform == nil)
        cform = [self getField:6];
    
    return cform;
}

-(NSString *)getReading{
    if(read == nil)
        read = [self getField:8];
    
    return read;
}

-(NSString *)getSurface{
    if(nodeStr == nil)
        nodeStr = [self getField:0];
    
    return nodeStr;
}

-(NSString *)getTermInfo{
    if(termInfo == nil){
        if(termInfoArray == nil)
            [self getField:0];
        
        NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
        for(int i=1;i < 10;i++){
            [tmpArray addObject:[self getField:i]];
        }
        
        NSArray *subArray = [tmpArray subarrayWithRange:NSMakeRange(0,9)];
        termInfo = [subArray componentsJoinedByString:@","];
    }
    
    return termInfo;
}

-(NSString *)getAddInfo{
    return addInfo;
}

-(NSString *)getField:(int)index{
    if(termInfoArray == nil){
        termInfoArray = [feature componentsSeparatedByString:@","];
    }
    
    if(index >= termInfoArray.count)
        return @"*";
    else
        return termInfoArray[index];
}

-(NSString *)toString{
    return [self getSurface];
}

@end
