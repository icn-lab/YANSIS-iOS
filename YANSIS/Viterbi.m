//
//  Viterbi.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import"Viterbi.h"

@implementation Viterbi{
    Tokenizer *tokenizer;
    Node *eosNode;
    Node *bosNode;
    NSString *sentence;
    int len;
    NSMutableArray *lookupCache;
    NSMutableArray *endNodeList;
}

-(id)init{
    if(self = [super init]){
        tokenizer = nil;
    }
    return self;
}

-(id)initWithTokenizer:(Tokenizer *)t{
    if(self = [self init]){
        tokenizer = t;
        [self initialize];
    }
    
    return self;
}

-(void)initialize{
    endNodeList = nil;
    lookupCache = nil;
    bosNode = [tokenizer getBOSNode];
    eosNode = [tokenizer getEOSNode];
    NSLog(@"initialize done");
}

-(Node *)lookup:(int)pos{
    Node *resultNode = nil;
    
    if([self getNodeFromArray:pos array:lookupCache] != nil){
        for(Node *node = [self getNodeFromArray:pos array:lookupCache]; node != nil;node = node.rnext){
            Node *newNode = [tokenizer getNewNode];
            int _id = newNode.id;
            [newNode copy:node];
            newNode.rnext = resultNode;
            newNode.id = _id;
            resultNode = newNode;
        }
    }
    else{
        //NSLog(@"lookup begin");
        resultNode = [tokenizer lookup:sentence begin:pos];
        //NSLog(@"resultNode:%@", [resultNode toString]);
        //NSLog(@"lookup end");
        lookupCache[pos] = resultNode;
    }
    
    return resultNode;
}

-(Node *)analyze:(NSString *)_sentence{
    sentence = _sentence;
    
    len = (int)[sentence length];
   
    NSLog(@"sentence=%@, len=%d", sentence, len);
    [self initialize];
    
    endNodeList = [[NSMutableArray alloc] initWithCapacity:(len+1)];
    lookupCache = [[NSMutableArray alloc] initWithCapacity:(len+1)];
    for(int i=0;i < len+1;i++){
        endNodeList[i] = [NSNull null];
        lookupCache[i] = [NSNull null];
    }
    endNodeList[0] = bosNode;
    NSLog(@"start");
    for(int pos=0;pos < len;pos++){
        if([self getNodeFromArray:pos array:endNodeList] != nil){
            Node *rNode = [self lookup:pos];
            //NSLog(@"rNode:%@", [rNode toString]);
            if(rNode != nil){
                [self calcConnectCost:pos rNode:rNode];
            }
        }
    }
    NSLog(@"step1 finished");
    
    for(int pos = len;pos >= 0;pos--){
        if([self getNodeFromArray:pos array:endNodeList] != nil){
            [self calcConnectCost:pos rNode:eosNode];
            break;
        }
    }
    NSLog(@"step2 finished");
    
    Node *node = eosNode;
    
    for(Node *prevNode; node.prev != nil;){
        prevNode = node.prev;
        prevNode.next = node;
        node = prevNode;
    }
    
    NSLog(@"analized");
    
    for(Node *it=bosNode.next;it != nil && it.surface != nil; it = it.next){
        it.termInfo = [tokenizer.dic getPosInfo:it.token.posID];
        //NSLog(@"%@", [it toString]);
    }
    
    NSLog(@"viterbi finished");
    return bosNode;
}

-(void)calcConnectCost:(int)pos rNode:(Node *)rNode{
    //NSLog(@"calcConnectCost");
    for(;rNode != nil;rNode=rNode.rnext){
        //NSLog(@"rNode:%@", [rNode toString]);
        int bestCost = INT_MAX;
        Node *bestNode = nil;
        
        for(Node *lNode = [self getNodeFromArray:pos array:endNodeList];lNode != nil;lNode = lNode.lnext){
            //NSLog(@"lNode:%@", [lNode toString]);
            int cost = lNode.cost + [tokenizer getCost:lNode.prev lNode:lNode rNode:rNode];
            if(cost <= bestCost){
                bestNode = lNode;
                bestCost = cost;
            }
        }
        
        //NSLog(@"rNode.prev");
        rNode.prev = bestNode;
        rNode.cost = bestCost;
        int x = rNode.end + pos;
        //NSLog(@"x=%d", x);
        rNode.lnext = [self getNodeFromArray:x array:endNodeList];
        
        endNodeList[x] = rNode;
        
        if(rNode.token.rcAttr2 != 0){
            int pos2 = rNode.end + pos;
            if(pos2 == len)
                continue;
            Node *rNode2 = [self lookup:pos2];
            for(;rNode2 != nil;rNode2=rNode2.rnext){
                rNode2.cost = rNode.cost + [tokenizer getCost:rNode.prev lNode:rNode rNode:rNode2];
                rNode2.prev = rNode;
            
                int y = rNode2.end + pos2;
                rNode2.lnext = [self getNodeFromArray:y array:endNodeList];
                endNodeList[y] = rNode2;
            }
        }
    }
}

-(Node *)getNodeFromArray:(int)pos array:(NSMutableArray*)array{
    if(array[pos] == [NSNull null])
        return nil;
    
    return array[pos];
}
@end