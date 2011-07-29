@import <Foundation/Foundation.j>
@import "OJTestCase.j"
@import "OJTestSuite.j"
@import "OJTestResult.j"
@import "OJTestListenerText.j"
@import <OJCov/OJCoverageListener.j>
@import <OJCov/OJCoverageReporter.j>

var stream = require("term").stream;

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
    
    if(!testCaseFile || testCaseFile == "")
    {
        [self report];
        return;
    }

    var matches = testCaseFile.match(/([^\/]+)\.j$/);
    
    if (matches)
    {

        system.stderr.write(matches[1]).flush();
        var testCaseClass = matches[1];
    
        [self beforeRequire];
        require(testCaseFile);

        var suite = [self getTest:testCaseClass];
        [self run:suite];
        [self afterRun];
        system.stderr.write("\n").flush();
    }
    else
        system.stderr.write("Skipping " + testCaseFile + ": not an Objective-J source file.\n").flush();
    
    // run the next test when this is done
    [self startWithArguments:args];
}

- (void)beforeRequire
{
    // do nothing. This is for subclassing purposes.
}

- (void)afterRun
{
    // do nothing. This is for subclassing purposes.
}

- (CPString)nextTest:(CPArray)args
{
    return require("file").absolute(args.shift());
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

    if (!totalErrors) {
        stream.print("\0green(All tests passed in the test suite.\0)");
        return CPLog.info("End of all tests.");
    }

    stream.print("Test suite failed with \0red(" + [[_listener errors] count] + 
        " errors\0) and \0red(" + [[_listener failures] count] + " failures\0).");
    CPLog.info("Test suite failed with "+[[_listener errors] count]+" errors and "+[[_listener failures] count]+" failures.");
    
    [self exit];
}

- (void)exit
{
    require("os").exit(1);
}

@end
