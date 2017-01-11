//
//  Tokenizer.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Tokenizer.h"

@implementation Tokenizer{
    int _id;
    Node *bosNode2;
    Node *eosNode;
    NSArray *matrix;
    int msize1;
    int msize2;
    int msize3;
}
-(id)init{
    if(self = [super init]){
        bosNode2 = [[Node alloc] init];
        eosNode  = [[Node alloc] init];
        self.bosNode = [[Node alloc] init];
        _id = 0;
    }
    return self;
}

-(id)initWithFiles:(NSString *)tokenFile doubleArrayFile:(NSString *)doubleArrayFile posInfoFile:(NSString *)posInfoFile connectFile:(NSString *)connectFile charset:(NSStringEncoding)charset{
    
    if(self = [self init]){
        self.dic = [[Dictionary alloc] initWithFile:tokenFile doubleArrayFile:doubleArrayFile posInfoFile:posInfoFile charset:charset];
    
        self.bosToken  = [self.dic getBOSToken];
        self.bosToken2 = [self.dic getBOSToken];
        self.eosToken  = [self.dic getEOSToken];
        self.unknownToken = [self.dic getUnknownToken];
        self.unknownToken.cost = 30000;
        [self loadConnectCost:connectFile];
    }
    
    return self;
}

-(void)loadConnectCost:(NSString *)connectFile{
    //FileAccessor *fa = [[FileAccessor alloc] initWithFile:connectFile];
    DataAccessor *fa = [[DataAccessor alloc] initWithFile:connectFile];
    msize1 = [fa readShort];
    msize2 = [fa readShort];
    msize3 = [fa readShort];
    
    int len = ((int)[fa length] - (3 * 2))/2;
    NSLog(@"msize1=%d", msize1);
    NSLog(@"msize2=%d", msize2);
    NSLog(@"msize3=%d", msize3);
    NSLog(@"matrix size = %d", len);
    
    NSMutableArray *__matrix = [[NSMutableArray alloc] initWithCapacity:len];
    for(int i=0;i < len;i++){
        __matrix[i] = [[NSNumber alloc] initWithShort:[fa readShort]];
    }
    matrix = [[NSArray alloc] initWithArray:__matrix];
    [fa close];
}

-(int)skipCharClass:(NSString *)s begin:(int)begin end:(int)end char_class:(int)char_class fail:(int *)fail{
    
    int p = begin;
    
    while(p != end && (fail[0] = [self getCharClass:[s characterAtIndex:p]]) == char_class) p++;
    
    if(p == end){
        fail[0] = 0;
    }
    
    
    return p;
}

-(int)skipCharClass:(NSString *)s begin:(int)begin end:(int)end char_class:(int)char_class{
    int p = begin;
    
    while(p != end && [self getCharClass:[s characterAtIndex:p]] == char_class)
        p++;
    
    return p;
}

-(int)getCharClass:(unichar)c{
    return 0;
}

-(Node *)lookup:(NSString *)s begin:(int)begin{
    return nil;
}

-(void)clear{
    _id = 0;
}

-(Node *)getNewNode{
    Node *node = [[Node alloc] init];
    node.id = _id++;
    return node;
}

-(Node *)getBOSNode{
    [self.bosNode clear];
    [bosNode2 clear];
    self.bosNode.prev = bosNode2;
    self.bosNode.surface = bosNode2.surface = nil;
    self.bosNode.length = bosNode2.length = 0;
    self.bosNode.token = self.bosToken;
    bosNode2.token = self.bosToken2;

    return self.bosNode;
}

-(Node *)getEOSNode{
    [eosNode clear];
    eosNode.surface = nil;
    eosNode.length = 1;
    eosNode.token = self.eosToken;

    return eosNode;
}

-(int)getCost:(Node *)lNode2 lNode:(Node *)lNode rNode:(Node *)rNode{
    if(rNode.token == nil){
        NSLog(@"nil!!");
        exit(1);
    }
    int pos = msize3 * (msize2 * lNode2.token.rcAttr2 + lNode.token.rcAttr1) + rNode.token.lcAttr;
    //NSLog(@"pos:%d", pos);
    if(pos >= [matrix count]){
        //NSLog(@"error pos=%d", pos);
        //NSLog(@"matrix=%d", (int)[matrix count]);
    }
    //NSLog(@"token.cost:%d", rNode.token.cost);
    return [matrix[pos] shortValue]+ rNode.token.cost;
}

@end
