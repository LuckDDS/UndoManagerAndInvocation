//
//  UndoAndInvocation.h
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/26.
//  Copyright © 2020 九天. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UndoAndInvocation : NSObject
- (void)addObject:(NSString *)object;
- (void)removeObject:(NSString *)object;

- (void)printData;
@end

NS_ASSUME_NONNULL_END
