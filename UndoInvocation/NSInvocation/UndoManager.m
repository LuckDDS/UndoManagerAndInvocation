//
//  UndoManager.m
//  ObjectMode
//
//  Created by 董德帅 on 2020/6/25.
//  Copyright © 2020 九天. All rights reserved.
//

#import "UndoManager.h"

@implementation UndoManager
{
    NSUndoManager * undoManager;
    //测试数组
    NSMutableArray * titleArr;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始话undoManager
        undoManager = [[NSUndoManager alloc]init];
        //初始话测试数组
        titleArr = [NSMutableArray new];
        
        //接下来就开始测试了
        [self addTitleWithStr:@"栈1"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(2);
            [self addTitleWithStr:@"栈2"];
        });
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(4);
            //执行撤销操作
            if ([self->undoManager canUndo]) {
                [self->undoManager undo];
            }
            NSLog(@"titleArr:%@",self->titleArr);
            //执行恢复操作
            if ([self->undoManager canRedo]) {
                [self->undoManager redo];
            }
            NSLog(@"titleArr:%@",self->titleArr);

        });
        
        
        //上面我使用线程操作是为了告诉各位一件事,就是说undo栈和redo栈其实对添加进来的方法NSInvocation是有进一步的包装的在一个runloop执行完毕时,把这一个runloop期间添加进栈的包到一起,这些就是一个小团队
        //举个例子就是redo或undo栈就是一个数组A,然后数组A里面包含多个数组,每个数组里面放的是一个runloop周期内加进来的NSInvocation.每次执行undo或redo操作时,操作的是A数组里面的小数组里面的所有操作.当然如果你觉得在一个runloop周期内你的操作不能执行完,比如画板涂鸦绘画的过程很长绝对不是一个runloop能解决的,那么可以使用[undoManager beginUndoGrouping];[undoManager endUndoGrouping];这两个方法,在这两个方法之间所有注册的undo里面的都会放到小数组里面,下次撤销或恢复时都会一起执行的.

    }
    return self;
}

- (void)addTitleWithStr:(NSString *)str{
    
    //执行的操作每一步都需要registerUndoWithTarget一次,将方法和参数都放到undo栈中,划重点->注册的是逆向操作删除
    //当执行undo(撤销)操作时我们需要从undo栈顶取出存入的操作并执行,我们这个方法是存入,所以相应的反操作就是删除
    //从这里可以看到NSMutableArray也可以注册NSUndoManager
    [undoManager registerUndoWithTarget:self selector:@selector(removeTitle:) object:str];
    
    //然后将数据添加到数组
    [titleArr addObject:str];
    
}

- (void)removeTitle:(NSString *)str{
    
    //这个removeTitle:方法就是对应的撤销操作,不会调用removeTitle:这个方法,调用这个方法是[undoManager undo]
    
    //在这里我们还需要注册一次addTitleWithStr:,为什么呢?
    //原因是一个很奇怪的原则,就是当执行[undoManager undo]操作时,执行registerUndoWithTarget:方法,这个内容会注册到redo的栈中.
    //所以我们接下来执行[undoManager redo]操作时会调用addTitleWithStr:这个方法,依次类推会一直循环下去
    
    //这里呢也证明了一点,执行[undoManager undo]操作时undo栈顶的会出栈
    //执行[undoManager redo]操作时redo栈顶的也会出栈
    [undoManager registerUndoWithTarget:self selector:@selector(addTitleWithStr:) object:str];
    [titleArr removeObject:str];

}
@end
