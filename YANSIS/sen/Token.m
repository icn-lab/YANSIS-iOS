//
//  Token.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/15.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "Token.h"

@implementation Token{
    Node *node;
    NSString *pos;
    NSString *pronunciation;
    NSString *basic;
    NSString *cform;
    NSString *read;
    NSString *nodeStr;
    NSString *termInfo;
    
    NSString *addInfo;
    int cost;
    int start;
    int length;
}

-(id)init{
    if(self=[super init]){
        node = [[Node alloc] init];
        pos = nil;
        pronunciation = nil;
        basic = nil;
        cform = nil;
        read  = nil;
        nodeStr = nil;
        termInfo = nil;
        addInfo = nil;
        cost = -1;
        start = -1;
        length = -1;
    }
    
    return self;
}

-(id)initWithNode:(Node *)n{
    if(self = [super init]){
        node = n;
        pos = [node getPos];
    }
    
    return self;
}

-(int)_start{
    if(start == -1){
        start = [node begin];
    }
    return start;
}

-(void)setStart:(int)s{
    start = s;
}

-(int)end{
    return [self _start] + [self length];
}

-(int)length{
    if(length == -1){
        length = [node length];
    }
    return length;
}

-(void) setLength:(int)l{
    length = l;
    if(node != nil){
        node.length = l;
    }
}

-(NSString *)getPos{
    return pos;
}

-(void)setPos:(NSString *)_pos{
    pos = _pos;
}

-(NSString *)getBasicString{
    if(basic == nil){
        basic = [node getBasicString];
    }
    return basic;
}

-(void)setBasicString:(NSString *)_basic{
    basic = _basic;
}

-(NSString *)getCform{
    if(cform == nil){
        cform = [node getCform];
    }
    return cform;
}

-(void)setCform:(NSString *)_cform{
    cform = _cform;
}

-(NSString *)getReading{
    if(read == nil){
        read = [node getReading];
    }
    return read;
}

-(void)setReading:(NSString *)_read{
    read = _read;
}

-(NSString *)getPronunciation{
    if(pronunciation == nil){
        pronunciation = [node getPronunciation];
    }
    return pronunciation;
}

-(void)setPronunciation:(NSString *)_pronunciation{
    pronunciation = _pronunciation;
}

-(NSString *)getSurface{
    if(nodeStr == nil){
        nodeStr = [node toString];
    }
    return nodeStr;
}

-(void)setSurface:(NSString *)_surface{
    nodeStr = _surface;
}

-(int)getCost{
    if(cost == -1){
        cost = [node getCost];
    }
    return cost;
}

-(void)setCost:(int)_cost{
    cost = _cost;
}

-(NSString *)getAddInfo{
    if(addInfo == nil){
        addInfo = [node getAddInfo];
    }
    return addInfo;
}

-(void)setAddInfo:(NSString *)_addInfo{
    addInfo = _addInfo;
}

-(NSString *)getTermInfo{
    if(termInfo == nil){
        termInfo = node.termInfo;
    }
    return termInfo;
}

-(void)setTermInfo:(NSString *)_termInfo{
    termInfo = _termInfo;
}

-(NSString *)toString{
    return [self getSurface];
}

@end