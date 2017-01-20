//
//  DoubleArrayTrie.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/10.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_DoubleArrayTrie_h
#define YANSIS_DoubleArrayTrie_h

#import <Foundation/Foundation.h>
#import "DataAccessor.h"
#import "FileAccessor.h"

#define _max(x,y) (((x)>(y))?(x):(y))
#define _check_size(x) {\
int t = (int)(x);\
if(t>alloc_size) {\
[self resize:(int)(t*1.05)];\
}\
}

// even is base array for Double Array Trie
#define _base(x) arrayInt[((int)x) << 1]

// odd is check array for Double Array Trie
#define _check(x) arrayInt[(((int)x) << 1) +1]

@interface _Node : NSObject
@property(nonatomic) int code;
@property(nonatomic) int depth;
@property(nonatomic) int left;
@property(nonatomic) int right;
@end

@interface DoubleArrayTrie : NSObject
-(id)init;
-(void)load:(NSString *)filename;
-(NSMutableArray *)_resize:(NSMutableArray *)ptr n:(int)n l:(int)l v:(int)v;
-(int)resize:(int)new_size;
-(int)fetch:(_Node *)parent siblings:(NSMutableArray *)siblings;
-(int)insert:(NSMutableArray *)siblings;
-(void)clear;
-(int)get_unit_size;
-(int)get_size;
-(int)get_nonzero_size;
-(int)build:(NSArray *)_str len:(NSArray *)_len val:(NSArray *)_val;
-(int)build:(NSArray *)_str len:(NSArray *)_len val:(NSArray *)_val size:(int)size;
-(int)search:(NSString *)_key pos:(int)pos len:(int)len;
-(int)commonPrefixSearch:(NSString *)key result:(NSMutableArray *)result pos:(int)pos len:(int)len;
-(void)dumpChar:(NSString *)c message:(NSString *)message;
@end
#endif
