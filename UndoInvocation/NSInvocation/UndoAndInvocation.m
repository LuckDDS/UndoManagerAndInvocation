//
//  UndoAndInvocation.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/26.
//  Copyright © 2020 九天. All rights reserved.
//

#import "UndoAndInvocation.h"

@implementation UndoAndInvocation
{
    NSMutableArray * arrData;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        arrData = [NSMutableArray new];
    }
    return self;
}

- (void)addObject:(NSString *)object{
    [arrData addObject:object];
}

- (void)removeObject:(NSString *)object{
    [arrData removeObject:object];
}

- (void)printData{
    NSLog(@"%@",arrData);
}
@end
