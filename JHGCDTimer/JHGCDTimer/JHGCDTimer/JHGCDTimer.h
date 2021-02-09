//
//  JHGCDTimer.h
//  JHGCDTimer
//
//  Created by HaoCold on 2021/2/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHGCDTimer : NSObject

+ (NSString *)timerWithStart:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(nullable dispatch_queue_t)queue task:(dispatch_block_t)task;

+ (NSString *)timerWithTarget:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue;

+ (void)cancelTimerWithID:(NSString *)ID;

@end

NS_ASSUME_NONNULL_END
