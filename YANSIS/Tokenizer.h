//
//  Tokenizer.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_Tokenizer_h
#define YANSIS_Tokenizer_h

#import<Foundation/Foundation.h>
#import"Node.h"
#import"CToken.h"
#import"Dictionary.h"
#import"FileAccessor.h"
#import"DataAccessor.h"

@interface Tokenizer : NSObject
@property(nonatomic) Dictionary *dic;
@property(nonatomic) CToken *bosToken;
@property(nonatomic) CToken *bosToken2;
@property(nonatomic) CToken *eosToken;
@property(nonatomic) CToken *unknownToken;
@property(nonatomic) Node *bosNode;

-(id)init;
-(id)initWithFiles:(NSString *)tokenFile doubleArrayFile:(NSString *)doubleArrayFile posInfoFile:(NSString *)posInfoFile connectFile:(NSString *)connectFile charset:(NSStringEncoding)charset;
-(void)loadConnectCost:(NSString *)connectFile;
-(int)skipCharClass:(NSString *)s begin:(int)begin end:(int)end char_class:(int)char_class fail:(int *)fail;
-(int)skipCharClass:(NSString *)s begin:(int)begin end:(int)end char_class:(int)char_class ;
-(int)getCharClass:(unichar)c;
-(Node *)lookup:(NSString *)s begin:(int)begin;
-(void)clear;
-(Node *)getNewNode;
-(Node *)getBOSNode;
-(Node *)getEOSNode;
-(int)getCost:(Node *)lNode2 lNode:(Node *)lNode rNode:(Node *)rNode;

@end
#endif
