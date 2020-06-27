//
//  Invocation.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/26.
//  Copyright © 2020 九天. All rights reserved.
//

#import "Invocation.h"

@implementation Invocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)testMethodSignature{
    NSLog(@"私有方法也可以被外界访问");
}

- (NSString *)invocationTestObject:(NSString *)object withObject1:(NSString *)object1 withObject2:(NSString *)object2{
    NSLog(@"%@,%@,%@",object,object1,object2);
    return @"return";
}


@end
