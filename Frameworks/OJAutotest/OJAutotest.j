@import "../OJUnit/OJTestRunnerText.j"
OS = require("os");
SYSTEM = require("system");

@implementation OJAutotest : OJTestRunnerText
{
    CPArray         testsAlreadyRun;
    CPDate          lastRunTime;
}

+ (void)start
{
    [[[self alloc] init] start];
}

- (void)start
{
    files = new (require("jake").FileList)(@"Test/*.j");
    [self startWithArguments:files];
    
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
    
    files = new (require("jake").FileList)(@"Test/*.j");
    [self startWithArguments:files];
    
    [self loop];
}

- (CPString)nextTest:(CPArray)arguments
{
    var nextTest = require("file").absolute(arguments.shift());
    
    var lastModification = require("file").mtime(nextTest);
    
    return nextTest;
}

- (void)exit
{
    
}

@end