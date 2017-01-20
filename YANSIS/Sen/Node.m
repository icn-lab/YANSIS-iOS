//
//  Node.m
//  YANSIS
//
//  Created by 長野雄 on 2014/12/15.
//  Copyright (c) 2014年 長野雄. All rights reserved.
//

#import "Node.h"

@implementation Node{
    NSArray *termInfoStringArray;
}

-(id)init{
    if(self = [super init]){
        self.token = nil;
        self.prev  = nil;
        self.next  = nil;
        self.lnext = nil;
        self.rnext = nil;
        
        self.surface  = nil;
        self.termInfo = nil;
        termInfoStringArray = nil;
        self.addInfo  = nil;
        self.begin = 0;
        self.length = 0;
        self.end   = 0;
        
        self.cost = 0;
        self.id   = 0;
    }
    
    return self;
}

-(int)_start{
    return self.begin;
}

-(int)_end{
    return self.begin+self.length;
}

-(int)_length{
    return self.length;
}

-(NSString *)getPos{
    int cnt = 0;
    if(self.termInfo == nil){
        return nil;
    }
    
    if([self.termInfo length] == 0){
        NSLog(@"feature information is null at %@.", [self toString]);
        NSLog(@"token id = %d¥n", self.token.posID);
        NSLog(@"token rcAttr2 = %d", self.token.rcAttr2);
        NSLog(@"token rcAttr1 = %d", self.token.rcAttr1);
        NSLog(@"token lcAttr = %d", self.token.lcAttr);
        NSLog(@"token length = %d", self.token.length);
        NSLog(@"token cost = %d", self.token.cost);
        return nil;
    }
    
    unichar COMMA = L',';
    unichar ASTERISK = L'*';
    while([self.termInfo characterAtIndex:cnt++] != COMMA);
    if([self.termInfo characterAtIndex:cnt] != ASTERISK){
        while([self.termInfo characterAtIndex:cnt++] != COMMA);
        if([self.termInfo characterAtIndex:cnt] != ASTERISK){
            while([self.termInfo characterAtIndex:cnt++] != COMMA);
            if([self.termInfo characterAtIndex:cnt] != ASTERISK){
                while([self.termInfo characterAtIndex:cnt++] != COMMA);
            }
        }
    }
    
    return [[self.termInfo substringWithRange:NSMakeRange(0, cnt-1)] stringByReplacingOccurrencesOfString:@"," withString:@"-"];
}

-(NSString *)getBasicString{
    if(self.termInfo == nil)
        return [self toString];
    
    if([self.termInfo length] == 0){
        NSLog(@"feature information is null at %@.", [self toString]);
        NSLog(@"token id = %d", self.token.posID);
        NSLog(@"token rcAttr2 = %d", self.token.rcAttr2);
        NSLog(@"token rcAttr1 = %d", self.token.rcAttr1);
        NSLog(@"token lcAttr = %d", self.token.lcAttr);
        NSLog(@"token length = %d", self.token.length);
        NSLog(@"token cost = %d", self.token.cost);
        
        return nil;
    }
    //NSLog(@"posInfo=%@", self.termInfo);
    return [self getField:6];
}

-(void)clear{
    self.token = nil;
    self.prev  = nil;
    self.next  = nil;
    self.lnext = nil;
    self.rnext = nil;
    self.surface = nil;
    self.termInfo = nil;
    self.addInfo = nil;
    self.begin = 0;
    self.length = 0;
    self.end = 0;
    self.cost = 0;
    self.id = 0;
}

-(void)copy:(Node *)org{
    self.token = org.token;
    self.prev  = org.prev;
    self.next  = org.next;
    self.lnext = org.lnext;
    self.rnext = org.rnext;
    self.surface = org.surface;
    self.termInfo = org.termInfo;
    self.addInfo = org.addInfo;
    self.begin = org.begin;
    self.length = org.length;
    self.end = org.end;
    self.cost = org.cost;
    self.id = org.id;
}

-(NSString *)toString{
    if(self.surface != nil){
        return [self.surface substringWithRange:NSMakeRange(self.begin, self.length)];
    }
    else{
        return nil;
    }
}

-(NSString *)getCform{
    if(self.termInfo == nil || [self.termInfo length] == 0)
        return nil;

    
    return [self getField:5];
}

-(NSString *)getReading{
    if(self.termInfo == nil || [self.termInfo length] == 0)
        return nil;

    return [self getField:7];
}

-(NSString *)getPronunciation{
    if(self.termInfo == nil || [self.termInfo length] == 0)
        return nil;
    
    return [self getField:8];

}

-(NSString *)getAddInfo{
    if(self.addInfo == nil){
        return [[NSString alloc] init];
    }
    
    return self.addInfo;
}

-(int)getCost{
    return self.cost;
}

-(NSString *)getField:(int)index{
    if(termInfoStringArray == nil){
        //NSLog(@"CSVParser alloc");
        //NSLog(@"terminfo:[%@]", self.termInfo);
        CSVParser *parser = [[CSVParser alloc] initWithString:self.termInfo];
        termInfoStringArray = [parser nextTokens];
       // for(NSString *ti in termInfoStringArray){
       //     NSLog(@"[%@]", ti);
       // }
    }
    
    return [termInfoStringArray[index] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
