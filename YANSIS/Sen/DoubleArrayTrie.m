//
//  DoubleArrayTrie.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/10.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "DoubleArrayTrie.h"

@implementation _Node
-(id)init{
    self = [super init];
    return self;
}
@end

@implementation DoubleArrayTrie {
    int BUF_SIZE;
    NSMutableArray *arrayInt;
    NSMutableArray *usedInt;
    int size;
    
    int alloc_size;
    NSArray *strData;
    int str_size;
    NSArray *lenInt;
    int len_length;
    NSArray *valInt;
    int val_length;
    
    int next_check_pos;
    int no_delete;
}

-(id)init{
    if(self = [super init]){
        BUF_SIZE = 500000;
        arrayInt = nil;
        usedInt  = nil;
        
        size       = 0;
        alloc_size = 0;
        no_delete  = 0;
    }
    
    return self;
}

-(void)load:(NSString *)filename{
    @autoreleasepool {
    //FileAccessor *fa = [[FileAccessor alloc] initWithFile:filename];
    DataAccessor *fa = [[DataAccessor alloc] initWithFile:filename];
    
    unsigned long long fsize = [fa length];

    unsigned long long arraySize = fsize / 4;
    arrayInt = [[NSMutableArray alloc] initWithCapacity:arraySize];
    
    for(unsigned long long i=0;i < arraySize;i++){
        arrayInt[i] = [[NSNumber alloc] initWithInt:[fa readInt]];
    }
    }
}

-(NSMutableArray *)_resize:(NSMutableArray *)ptr  n:(int)n l:(int)l v:(int)v {
   
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:l];
    
    int ll = 0;

    if(ptr != nil){
        ll = (int)[ptr count];
    }
    else{
        ll = 0;
    }
    
    for(int i=0;i < ll;i++) tmp[i] = ptr[i];
    for(int i=ll;i < l;i++) tmp[i] = [[NSNumber alloc] initWithInt:v];

    ptr = nil;

    return tmp;
}

-(int)resize:(int)new_size{
    arrayInt = [self _resize:arrayInt n:alloc_size << 1 l:new_size << 1 v:0];
    usedInt  = [self _resize:usedInt n:alloc_size l:new_size v:0];
    
    alloc_size = new_size;
    
    return new_size;
}

-(int)fetch:(_Node *)parent siblings:(NSMutableArray *)siblings{
    int prev = 0;
    for(int i=parent.left;i < parent.depth;i++){
        if(((lenInt != nil)?[lenInt[i] intValue]:[strData[i] length]) < parent.depth)
            continue;
        
        const char *tmp = [strData[i] bytes];
        
        int cur = 0;
        if(((lenInt !=nil) ? [lenInt[i] intValue]:[strData[i] length]) != parent.depth)
            cur = (int)tmp[parent.depth]+1;
    
        if(prev > cur){
            NSLog(@"Fatal: given strings are not sorted.¥n");
            exit(1);
        }
        
        if(cur != prev || [siblings count] == 0){
            _Node *tmp_node = [_Node alloc];
            tmp_node.depth = parent.depth + 1;
            tmp_node.code  = cur;
            tmp_node.left  = i;
            if([siblings count] != 0){
                _Node *last = [siblings lastObject];
                last.right = i;
            }
            
            [siblings addObject:tmp_node];
        }
        
        prev = cur;
    }
    
    if([siblings count] != 0){
        _Node *last = [siblings lastObject];
        last.right = parent.right;
    }
    
    return (int)[siblings count];
}

-(int)insert:(NSMutableArray *)siblings{
    int begin = 0;
    _Node *firstNode = [siblings firstObject];
    int pos         = ((firstNode.code + 1)>((int)next_check_pos))?(firstNode.code + 1):next_check_pos - 1;
    
    int nonzero_num = 0;
    int first       = 0;
    
    while(true){
        pos++;
        { int t = (int)(pos); if(t>alloc_size) { [self resize:(int)(t*1.05)]; }};

        if ([arrayInt[(((int)pos) << 1) + 1] intValue]!=0) {
            nonzero_num++;
            continue;
        }
        else if(first == 0){
            next_check_pos = pos;
            first = 1;
        }
        
        _Node *firstNode = [siblings firstObject];
        begin = pos - firstNode.code;
        
        _Node *lastNode = [siblings lastObject];
        { int t = (int)(begin + lastNode.code); if(t>alloc_size) { [self resize:(int)(t*1.05)]; }};
        
        if([usedInt[begin] intValue]!=0) continue;
        
        Boolean flag = false;
        
        for(int i=1;i <[siblings count];i++){
            _Node *iNode = siblings[i];
            if ([arrayInt[((begin + iNode.code) << 1) + 1] intValue] != 0) {
                flag = true;
                break;
            }
        }
        if(!flag) break;
    }

    // -- Simple heuristics --
    // if the percentage of non-empty contents in check between the index
    // 'next_check_pos' and 'check' is grater than some constant value (e.g. 0.9),
    // new 'next_check_pos' index is written by 'check'.
    if (1.0 * nonzero_num/(pos - next_check_pos + 1) >= 0.95) next_check_pos = pos;
    usedInt[begin] = [[NSNumber alloc ] initWithInt:1];
    _Node *lastNode = [siblings lastObject];
    size     = (size > (begin + lastNode.code + 1))?(size):(begin + lastNode.code + 1);
    
    for (int i = 0; i < [siblings count]; i++) {
        _Node *iNode = siblings[i];
        arrayInt[((begin + iNode.code) << 1)+1] = [[NSNumber alloc] initWithInt:begin];
    }
    
    for(int i=0;i < [siblings count];i++){
        NSMutableArray *new_siblings = [[NSMutableArray alloc] init];
        _Node *iNode = siblings[i];
        if([self fetch:iNode siblings:new_siblings]==0){
            arrayInt[(begin + iNode.code) << 1] =
            (valInt!=nil) ?
            [[NSNumber alloc] initWithInt:(int)(-[valInt[iNode.left] intValue]-1)]
            : [[NSNumber alloc] initWithInt:(int)(-iNode.left-1)];

            if((valInt != nil) &&
                (-[valInt[iNode.left] intValue]-1) >= 0){
                NSLog(@"negative value assigned.");
                exit(1);
            }
        }
        else{
            int ins = [self insert:new_siblings];
            arrayInt[(begin+iNode.code)<<1] = [[NSNumber alloc] initWithInt:ins];
        }
    }
    
    return begin;
}

-(void)clear{
    arrayInt = nil;
    usedInt  = nil;
    alloc_size = 0;
    size = 0;
    no_delete = 0;
}

-(int)get_unit_size{
    return 8;
}

-(int)get_size{
    return size;
}

-(int)get_nonzero_size{
    int result = 0;
    
    for(int i=0;i < size;i++)
        if([arrayInt[(i << 1)+1] intValue]!=0) result++;
    
    return result;
}

-(int)build:(NSArray *)_str len:(NSArray *)_len val:(NSArray *)_val{
    return [self build:_str len:_len val:_val size:(int)[_str count]];
}

-(int)build:(NSArray *)_str len:(NSArray *)_len val:(NSArray *)_val size:(int)lsize{
    
    if(_str == nil) return 0;
    if([_str count] != [_val count]){
        NSLog(@"index and text should be same size.");
        return 0;
    }
    
    strData = _str;
    lenInt  = _len;
    str_size = lsize;
    valInt  = _val;
    
    [self resize:(1024 * 10)];
    
    arrayInt[0 << 1] = [[NSNumber alloc] initWithInt:1];
    next_check_pos = 0;
    
    _Node *root_node = [_Node alloc];
    root_node.left = 0;
    root_node.right = str_size;
    root_node.depth = 0;
    
    NSMutableArray *siblings = [[NSMutableArray alloc] init];
    [self fetch:root_node siblings:siblings];
    [self insert:siblings];
    
    usedInt = nil;
    
    return lsize;
}

-(int)search:(NSString *)_key pos:(int)pos len:(int)len{
    if(len == 0) len = (int)[_key length];
    
    int b = [arrayInt[(int)0 << 1] intValue];
    int p;
    
    for(int i=pos;i < len;i++){
        unichar key = [_key characterAtIndex:i];
        p = b + key + 1;
        if(b == [arrayInt[(p<<1)+1] intValue]) b = [arrayInt[p<<1] intValue];
        else return -1;
    }
    
    p = b;
    int n = [arrayInt[p<<1] intValue];
    
    if(b==[arrayInt[(p<<1)+1] intValue] && n < 0) return (-n-1);
    return -1;
}

-(int)commonPrefixSearch:(NSString *)key result:(NSMutableArray *)result pos:(int)pos len:(int)len{
    
    if(len == 0) len = (int)[key length];
    
    int b = [arrayInt[((int)0) << 1] intValue];
    int num = 0;
    int n;
    int p;
    
    for(int i=pos;i < len;i++){
        p = b;
        //NSLog(@"p:%d",p);
        n = [arrayInt[((int)p)<<1] intValue];
        if(b == [arrayInt[(((int)p)<<1)+1] intValue] && n < 0){
            if(num < [result count]){
                result[num] = [[NSNumber alloc] initWithInt:(-n-1)];
            }
            else{
                NSLog(@"result array size may not enough");
            }
            num++;
        }
        
        p = b + [key characterAtIndex:i] + 1;
        
        if((p<<1) > [arrayInt count]){
            NSLog(@"p range is over.");
            NSLog(@"p<<1,array.length=(%d,%d)", (p<<1), (int)[arrayInt count]);
            return num;
        }
        
        if(b == [arrayInt[(p<<1)+1] intValue]){
            b = [arrayInt[(p<<1)] intValue];
        }
        else{
            return num;
        }
    }
    
    p = b;
    n = [arrayInt[(p<<1)] intValue];
    if(b==[arrayInt[(p<<1)+1] intValue] && n < 0){
        if(num < (int)[result count]){
            result[num] = [[NSNumber alloc] initWithInt:(-n-1)];
        }
        else{
            NSLog(@"result array size may not enough");
        }
        num++;
    }
        
    return num;
}

-(void)dumpChar:(NSString *)c message:(NSString *)message{
    NSLog(@"message=%@", message);
    for(int i=0;i < [c length];i++){
        NSLog(@"%c,", [c characterAtIndex:i]);
    }
}


@end
