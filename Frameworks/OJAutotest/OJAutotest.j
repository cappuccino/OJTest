@import <Foundation/CPObject.j>
@import <OJUnit/OJTestRunnerText.j>
OS = require("os");
SYSTEM = require("system");

@implementation OJAutotest : OJTestRunnerText

+ (void)start
{
    [[[self alloc] init] start];
}

- (void)start
{
    OS.system("ojtest Test/*.j");
    
    print("---------- STARTING LOOP ----------");
    print("In order to stop the tests, do Control-C in quick succession.");
    
    [self loop];
}

- (void)loop
{
    print("---------- WAITING FOR CHANGES ----------");
    var waitStatus = OS.system("ojautotest-wait Test");
    print("----------  CHANGES  DETECTED  ----------");
    
    OS.sleep(1);
    
    [self startWithArguments:[@"Test/*.j"]];
    
    [self loop];
}

@end