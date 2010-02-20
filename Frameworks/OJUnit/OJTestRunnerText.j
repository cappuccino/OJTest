@import <Foundation/Foundation.j>
@import "OJTestCase.j"
@import "OJTestSuite.j"
@import "OJTestResult.j"
@import "OJTestListenerText.j"

@implementation OJTestRunnerText : CPObject
{
    OJTestListener _listener;
}

- (id)init
{
    if (self = [super init])
    {
        _listener = [[OJTestListenerText alloc] init];
    }
    return self;
}

- (OJTest)getTest:(CPString)suiteClassName
{
    var testClass = objj_lookUpClass(suiteClassName);
    
    if (testClass)
    {
        var suite = [[OJTestSuite alloc] initWithClass:testClass];
        return suite;
    }
    
    CPLog.warn("unable to get tests");
    return nil;
}

- (void)startWithArguments:(CPArray)args
{
    if (args.length === 0)
    {
        [self report];
        return;
    }

    var testCaseFile = [self nextTest:args];

    var matches = testCaseFile.match(/([^\/]+)\.j$/);

    system.stderr.write(matches[1]).flush();
    var testCaseClass = matches[1];

    require(testCaseFile);

    var suite = [self getTest:testCaseClass];

    [self run:suite];
    system.stderr.write("\n").flush();
    
    // run the next test when this is done
    [self startWithArguments:args];
}

- (CPString)nextTest:(CPArray)arguments
{
    return require("file").absolute(arguments.shift());
}

- (OJTestResult)run:(OJTest)suite wait:(BOOL)wait
{
    var result = [[OJTestResult alloc] init];
    
    [result addListener:_listener];
    
    [suite run:result];
    
    return result;
}
- (OJTestResult)run:(OJTest)suite
{
    return [self run:suite wait:NO];
}

+ (void)runTest:(OJTest)suite
{
    var runner = [[OJTestRunnerText alloc] init];
    [runner run:suite];
}

+ (void)runClass:(Class)aClass
{
    [self runTest:[[OJTestSuite alloc] initWithClass:aClass]];
}

- (void)report
{
    var totalErrors = [[_listener errors] count] + [[_listener failures] count];

    if (!totalErrors)
        return CPLog.info("End of all tests.");

    CPLog.fatal("Test suite failed with "+[[_listener errors] count]+" errors and "+[[_listener failures] count]+" failures.");
    
    [self exit];
}

- (void)exit
{
    require("os").exit(1);
}

@end