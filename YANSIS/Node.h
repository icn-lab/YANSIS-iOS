//
//  Node.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/15.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_Node_h
#define YANSIS_Node_h

#import <Foundation/Foundation.h>
#import "CSVParser.h"
#import "CToken.h"

@interface Node : NSObject
@property(nonatomic) CToken *token;
@property(nonatomic) Node *prev;
@property(nonatomic) Node *next;
@property(nonatomic) Node *lnext;
@property(nonatomic) Node *rnext;
@property(nonatomic) NSString *surface;
@property(nonatomic) NSString *termInfo;
@property(nonatomic) NSString *addInfo;
@property(nonatomic) int begin;
@property(nonatomic) int length;
@property(nonatomic) int end;
@property(nonatomic) int cost;
@property(nonatomic) int id;

-(int)_start;
-(int)_end;
-(int)_length;
-(NSString *)getPos;
-(NSString *)getBasicString;
-(void)clear;
-(void)copy:(Node *)org;
-(NSString *)toString;
-(NSString *)getCform;
-(NSString *)getReading;
-(NSString *)getPronunciation;
-(NSString *)getAddInfo;
-(int)getCost;
-(NSString *)getField:(int)index;

@end

#endif
