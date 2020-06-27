//
//  InvocationViewController.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/25.
//  Copyright © 2020 九天. All rights reserved.
//

#import "InvocationViewController.h"
#import "UndoManager.h"
#import "UndoAndInvocation.h"
#import "Invocation.h"
@interface InvocationViewController ()

@end

@implementation InvocationViewController
{
    UndoManager * undoManage;
    Invocation * myInvocation;
    UndoAndInvocation * undoInvocation;
    NSUndoManager * myUndoManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSUndoManager的使用
    undoManage = [[UndoManager alloc]init];

    //invocation的使用
    [self invocationUsed];
    
    //NSUndoManager和NSInvocation的结合
    [self undoAndInvocation];
    // Do any additional setup after loading the view.
}

- (void)invocationUsed{
    
    myInvocation = [Invocation new];
    //获取方法的对象
    //publicInvocation是有返回值的
    NSInvocation * publicInvocation = [self buildPublicInvocation];
    //privateInvocation无参无返回值
    NSInvocation * privateInvocation = [self buildPrivateInvocation];
    
    //有参数的话需要设置参数
    //atIndex是在方法中参数的位置,从左往右数,不能是0和1,要记得0和1已经被占用了即可.
    NSString * object = @"object";
    NSString * object1 = @"object1";
    NSString * object2 = @"object2";

    [publicInvocation setArgument:&object atIndex:2];
    [publicInvocation setArgument:&object1 atIndex:3];
    [publicInvocation setArgument:&object2 atIndex:4];
    //设置接收返回值的对象
    NSString * returnValue;
    [publicInvocation setReturnValue:&returnValue];
    //调用方法
    [publicInvocation invoke];
    //接收返回值
    NSLog(@"%@",returnValue);
    //打印返回值
    [publicInvocation getReturnValue:&returnValue];
    NSLog(@"publicInvocation:%@",returnValue);
    
    //调用私有方法
    [privateInvocation invoke];
    

}

- (NSInvocation *)buildPublicInvocation{

    //初始化方法的签名,需要调用谁的方法就用谁去创建签名,这里是Invocation这个类的方法.
    //初始化方法的签名有两种这里是使用的类方法还有一种是对象方法
    NSMethodSignature * signature = [Invocation instanceMethodSignatureForSelector:@selector(invocationTestObject:withObject1:withObject2:)];
    //返回invocation对象
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    //设置invocation的目标对象
    [invocation setTarget:myInvocation];
    //设置需要调用的方法,切记需要和signature中的方法一致
    [invocation setSelector:@selector(invocationTestObject:withObject1:withObject2:)];
    return invocation;
}

- (NSInvocation *)buildPrivateInvocation{
    //初始化方法的签名,需要调用谁的方法就用谁去创建签名,这里是UndoManager这个类的方法.
    //初始化方法的签名有两种这里是使用的对象方法
    NSMethodSignature * signature = [myInvocation methodSignatureForSelector:@selector(testMethodSignature)];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:myInvocation];
    [invocation setSelector:@selector(testMethodSignature)];
    return invocation;
}

- (void)undoAndInvocation{
    undoInvocation = [UndoAndInvocation new];
    myUndoManager = [[NSUndoManager alloc]init];
    
    NSString * object = @"测试专用字符串";
    
    [self addObject:object];
    //打印数据
    [undoInvocation printData];

    //执行撤销操作
    [myUndoManager undo];
    //打印数据
    [undoInvocation printData];

    //执行恢复操作
    [myUndoManager redo];
    //打印数据
    [undoInvocation printData];
}

- (void)addObject:(NSString *)object{
    NSInvocation * invocation = [self buildAddInvocation];
    [invocation setArgument:&object atIndex:2];
    [invocation invoke];
    [[myUndoManager prepareWithInvocationTarget:self] removeObject:object];;
    
}

- (void)removeObject:(NSString *)object{
    
    NSInvocation * invocation = [self buildRemovaInvocation];
    [invocation setArgument:&object atIndex:2];
    [invocation invoke];
    [[myUndoManager prepareWithInvocationTarget:self] addObject:object];
}

- (NSInvocation *)buildAddInvocation{
    
    NSMethodSignature * signature = [UndoAndInvocation instanceMethodSignatureForSelector:@selector(addObject:)];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObject:)];
    [invocation setTarget:undoInvocation];
    return invocation;
}

- (NSInvocation *)buildRemovaInvocation{
    NSMethodSignature * signature = [UndoAndInvocation instanceMethodSignatureForSelector:@selector(removeObject:)];
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:undoInvocation];
    [invocation setSelector:@selector(removeObject:)];
    return invocation;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
