//
//  Viterbi.h
//  YANSIS
//
//  Created by 長野雄 on 2014/12/16.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#ifndef YANSIS_Viterbi_h
#define YANSIS_Viterbi_h

#import<Foundation/Foundation.h>
#import"Tokenizer.h"
#import"Node.h"

@interface Viterbi : NSObject
-(id)init;
-(id)initWithTokenizer:(Tokenizer *)t;
-(void)initialize;
-(Node *)lookup:(int)pos;
-(Node *)analyze:(NSString *)_sentence;
-(void)calcConnectCost:(int)pos rNode:(Node *)rNode;
-(Node *)getNodeFromArray:(int)pos array:(NSMutableArray *)array;
@end
#endif
