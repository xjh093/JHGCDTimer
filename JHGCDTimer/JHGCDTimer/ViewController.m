//
//  ViewController.m
//  JHGCDTimer
//
//  Created by HaoCold on 2021/2/9.
//

#import "ViewController.h"
#import "JHGCDTimer.h"


@interface ViewController ()
@property (nonatomic,    copy) NSString *timerID;
@property (nonatomic,    copy) NSString *timerID1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"111");
    
    _timerID = [JHGCDTimer timerWithStart:2 interval:1 repeats:YES queue:nil task:^{
        [self task];
    }];
    _timerID1 = [JHGCDTimer timerWithTarget:self selector:@selector(task1) start:3 interval:1 repeats:YES queue:dispatch_get_global_queue(0, 0)];
}

- (void)task
{
    NSLog(@"task - %@", [NSThread currentThread]);
}

- (void)task1
{
    NSLog(@"task - %@", [NSThread currentThread]);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [JHGCDTimer cancelTimerWithID:_timerID];
    [JHGCDTimer cancelTimerWithID:_timerID1];
}

@end
