//
//  JHGCDTimer.m
//  JHGCDTimer
//
//  Created by HaoCold on 2021/2/9.
//

#import "JHGCDTimer.h"

dispatch_semaphore_t _semaphore;
static NSMutableDictionary *_timers;

@implementation JHGCDTimer

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _timers = @{}.mutableCopy;
        _semaphore = dispatch_semaphore_create(1);
    });
}

+ (NSString *)timerWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue task:(dispatch_block_t)task
{
    if (start < 0 || (interval < 0 && repeats) || !task) {
        return nil;
    }
    
    if (!queue) {
        queue = dispatch_get_main_queue();
    }
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC, 0);
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    NSString *ID = [NSString stringWithFormat:@"JHGCDTimer-%zd", _timers.count];
    _timers[ID] = timer;
    dispatch_semaphore_signal(_semaphore);
    
    dispatch_source_set_event_handler(timer, ^{
        task();
        
        if (!repeats) {
            [self cancelTimerWithID:ID];
        }
    });
    dispatch_resume(timer);
    
    return ID;
}

+ (NSString *)timerWithTarget:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue
{
    if (!target || !selector) {
        return nil;
    }
    
    NSString *ID = [self timerWithStart:start interval:interval repeats:repeats queue:queue task:^{
        if ([target respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    }];
    return ID;
}

+ (void)cancelTimerWithID:(NSString *)ID
{
    if (!ID.length) {
        return;
    }
    
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = _timers[ID];
    if (timer) {
        dispatch_source_cancel(timer);
        [_timers removeObjectForKey:ID];
    }
    dispatch_semaphore_signal(_semaphore);
}

@end
