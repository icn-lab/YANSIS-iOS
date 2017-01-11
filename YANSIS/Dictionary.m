//
//  Dictionary.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/15.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//


#import "Dictionary.h"
#define BUFSIZE 1024

@implementation Dictionary{
    //FileAccessor *tfd;
    DataAccessor *tfd;
    NSFileHandle *ffd;
    DoubleArrayTrie *da;
    NSMutableArray *result;
    NSMutableArray *daresult;
    NSStringEncoding charset;
}

-(id)init{
    if(self = [super init]){
        tfd = nil;
        ffd = nil;
        int capacity = 256;
        da = [[DoubleArrayTrie alloc] init];
        result = [[NSMutableArray alloc] initWithCapacity:capacity];
        daresult = [[NSMutableArray alloc] initWithCapacity:capacity];
        for(int i=0;i < capacity;i++){
            result[i]   = [NSNull null];
            daresult[i] = [[NSNumber alloc] initWithInt:0];
        }
        charset = NSUTF8StringEncoding;
    }
    return self;
}

-(id)initWithFile:(NSString *)tokenFile doubleArrayFile:(NSString *)doubleArrayFile posInfoFile:(NSString *)posInfoFile charset:(NSStringEncoding)_charset{
    
    if(self = [self init]){
        charset = _charset;
        NSLog(@"charset:%d", (int)charset);
        //tfd = [[FileAccessor alloc] initWithFile:tokenFile];
        tfd = [[DataAccessor alloc] initWithFile:tokenFile];
        NSLog(@"double array trie dictionary = %@", doubleArrayFile);
        [da load:doubleArrayFile];
        
        NSLog(@"pos info file = %@", posInfoFile);
        ffd = [NSFileHandle fileHandleForReadingAtPath:posInfoFile];
    }
    return self;
}

-(NSArray *)commonPrefixSearch:(NSString *)str position:(int)pos{
    int size = 0;
    
    int n = [da commonPrefixSearch:str result:daresult pos:pos len:0];
    
    //NSLog(@"number of prefix = %d", n);
    
    for(int i=0;i < n;i++){
        int k = 0xff & [daresult[i] intValue];
        int p = [daresult[i] intValue] >> 8;
        //NSLog(@"n:%d k=%d p=%d", n, k, p);
        [tfd seek:(p+3)*[CToken SIZE]];
        for(int j=0;j < k;j++){
            result[size] = [[CToken alloc] init];
            [result[size] read:tfd];
            
            size++;
        }
    }
    
    result[size] = [NSNull null];
   
    return [NSArray arrayWithArray:result];
}

-(NSArray *)exactMatchSearch:(NSString *)str position:(int)pos{
    int size = 0;
    
    int n = [da search:str pos:pos len:0];
    
    if(n != -1){
        int k = 0xff & n;
        int p = n >> 8;
        
        [tfd seek:(p+3)*[CToken SIZE]];

        for(int i=0;i < k;i++){
            result[size] = [[CToken alloc] init];
            [result[size] read:tfd];
            CToken *ctoken = result[size];
            ctoken.length /= 2;
            size++;
        }
    }
    result[size] = [NSNull null];
    return [NSArray arrayWithArray:result];
}

-(NSString *)getPosInfo:(int)f{
    if(f == -1)
        return nil;
    [ffd seekToFileOffset:f];
    NSMutableData *data = [[NSMutableData alloc] init];
    
    while(1){
        @autoreleasepool {
            NSData *readByte = [ffd readDataOfLength:1];
            if(readByte != nil){
                const char *p = [readByte bytes];
                if(*p == '\0')
                    break;
                [data appendData:readByte];
            }
            else{
                break;
            }
        }
    }
    NSString *dString = [[NSString alloc ] initWithData:data encoding:NSJapaneseEUCStringEncoding];
    //NSLog(@"ret:[%@]", dString);
    
    return [NSString stringWithString:dString];
}

-(CToken *)getBOSToken{
    [tfd seek:0];
    CToken *t = [[CToken alloc] init];
    [t read:tfd];
    /*
    NSLog(@"getBOSToken()");
    NSLog(@"rcAttr2 = %d", t.rcAttr2);
    NSLog(@"rcAttr1 = %d", t.rcAttr1);
    NSLog(@"lcAttr1 = %d", t.lcAttr);
    NSLog(@"posid = %d", t.posid);
    NSLog(@"length = %d", t.length);
    NSLog(@"cost = %d", t.cost);
    NSLog(@"posID = %d", t.posID);
     */
    return t;
}

-(CToken *)getEOSToken{
    [tfd seek:[CToken SIZE] * 1];
    CToken *t = [[CToken alloc] init];
    [t read:tfd];
    /*
    NSLog(@"getEOSToken()");
    NSLog(@"rcAttr2 = %d", t.rcAttr2);
    NSLog(@"rcAttr1 = %d", t.rcAttr1);
    NSLog(@"lcAttr1 = %d", t.lcAttr);
    NSLog(@"posid = %d", t.posid);
    NSLog(@"length = %d", t.length);
    NSLog(@"cost = %d", t.cost);
    NSLog(@"posID = %d", t.posID);
     */
    return t;
}

-(CToken *)getUnknownToken{
    [tfd seek:[CToken SIZE] * 2];
    CToken *t = [[CToken alloc] init];
    [t read:tfd];
    /*
    NSLog(@"getUnknownToken()");
    NSLog(@"rcAttr2 = %d", t.rcAttr2);
    NSLog(@"rcAttr1 = %d", t.rcAttr1);
    NSLog(@"lcAttr1 = %d", t.lcAttr);
    NSLog(@"posid = %d", t.posid);
    NSLog(@"length = %d", t.length);
    NSLog(@"cost = %d", t.cost);
    NSLog(@"posID = %d", t.posID);
     */
    return t;
}
@end