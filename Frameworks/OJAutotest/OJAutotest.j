@import "../OJUnit/OJTestRunnerText.j"
OS = require("os");
SYSTEM = require("system");
FILE = require("file");

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
    [self runTests];
    
    print("---------- STARTING LOOP ----------");
    print("In order to stop the tests, do Control-C in quick succession.");
    
    [self loop];
}

- (void)loop
{
    print("---------- WAITING FOR CHANGES ----------");
    OS.system("ojautotest-wait Test");
    print("----------  CHANGES  DETECTED  ----------");
    
    OS.sleep(1);
    
    [self runTests];
    
    [self loop];
}

- (void)runTests
{
    var tests = [self testsOfFiles:[self files]];
    OS.system(["ojtest"].concat(tests));
    [self testsWereRun];
}

- (FileList)files
{
    return new (require("jake").FileList)(@"Test/*.j");
}

- (void)testsWereRun
{
    lastRunTime = [CPDate dateWithTimeIntervalSinceNow:0];
}

- (CPString)testsOfFiles:(FileList)someFileList
{
    var result = [CPArray array];
    var files = someFileList.items();
    
    if([files count] == 0)
        return result;
        
    for(var i = 0; i < [files count]; i++)
    {
        var nextTest = FILE.absolute([files objectAtIndex:i]);
    
        if([self testHasBeenModified:nextTest])
            [result addObject:nextTest];
    }
    
    return result;
}

- (BOOL)testHasBeenModified:(CPString)test
{
    var lastModification = FILE.mtime(test);
    return [lastModification compare:lastRunTime] > 0;
}

@end