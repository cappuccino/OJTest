@import "../OJUnit/OJTestRunnerText.j"
OS = require("os");
SYSTEM = require("system");
FILE = require("file");
OJAUTOTEST_RUNNER = FILE.join(SYSTEM.prefix, "packages", "ojtest", "Frameworks", "OJAutotest", "OJAutotestRunnerText.j");

@implementation OJAutotest : OJTestRunnerText
{
    CPArray         testsAlreadyRun;
    CPDate          lastRunTime;
    BOOL            isDirty;
}

+ (void)start
{
    [[[self alloc] init] start];
}

- (void)start
{
    isDirty = NO;
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
    var runnerResult = OS.system([OJAUTOTEST_RUNNER, isDirty].concat(tests));
    print(runnerResult);
    if(runnerResult == 0)
    {
        if(isDirty)
        {
            isDirty = NO;
            var allTestRun = OS.system([OJAUTOTEST_RUNNER, isDirty].concat([self files].items()));
            
            if(allTestRun !== 0)
            {
                isDirty = YES;
            }
        }
    }
    else
    {
        isDirty = YES;
    }

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