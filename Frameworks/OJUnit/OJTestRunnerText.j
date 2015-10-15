@import <Foundation/Foundation.j>
@import "OJTestCase.j"
@import "OJTestCase+Assert.j"
@import "OJTestSuite.j"
@import "OJTestResult.j"
@import "OJTestListenerText.j"
@import <OJCov/OJCoverageListener.j>
@import <OJCov/OJCoverageReporter.j>

var OS = require("os"),
    stream = require("narwhal/term").stream;

@implementation OJTestRunnerText : CPObject
{
    BOOL               _shouldStopAtFirstFailureOrError @accessors(property=shouldStopAtFirstFailureOrError);

    OJTestListenerText _listener;
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
    return [self getTest:suiteClassName selectorRegex:nil];
}

- (OJTest)getTest:(CPString)suiteClassName selectorRegex:(CPString)selectorRegex
{
    var testClass = objj_lookUpClass(suiteClassName);

    if (testClass)
    {
        var suite;

        if (selectorRegex)
            suite = [[OJTestSuite alloc] initWithClass:testClass selectorRegex:selectorRegex];
        else
            suite = [[OJTestSuite alloc] initWithClass:testClass];

        [suite setShouldStopAtFirstFailureOrError:_shouldStopAtFirstFailureOrError];

        return suite;
    }

    CPLog.warn("unable to get tests");
    return nil;
}

- (void)startWithArguments:(CPArray)args
{
    if (args.length === 0 || [self shouldStop])
    {
        [self report];
        return;
    }

    var testCaseFile = [self nextTest:args];

    if (!testCaseFile || testCaseFile == "")
    {
        [self report];
        return;
    }

    var matches = testCaseFile.match(/([^\/]+)\.j\:?([^\/]+)?$/);

    if (matches)
    {
        system.stderr.write(matches[1]).flush();

        var testCaseClass = matches[1],
            selectorRegex = matches[2];

        [self beforeRequire];
        require(testCaseFile.split(":")[0]);

        if (selectorRegex)
            selectorRegex = @"^"+selectorRegex+"$";

        var suite = [self getTest:testCaseClass selectorRegex:selectorRegex];
        [self run:suite];
        [self afterRun];
        system.stderr.write("\n").flush();

        if ([self shouldStop])
        {
            [self report];
            return;
        }
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

- (void)shouldStop
{
    if (!_shouldStopAtFirstFailureOrError)
        return NO;

    return [[_listener errors] count] || [[_listener failures] count];
}

- (void)report
{
    var totalTests = [[_listener errors] count] + [[_listener failures] count] + [[_listener successes] count],
        totalErrors = [[_listener errors] count] + [[_listener failures] count];

    if (totalErrors === 0)
    {
        stream.print("\0green(All tests passed in the test suite.\0)\nTotal tests: " + totalTests);
        OS.exit(0);
    }
    else
    {
        stream.print("Test suite failed with \0red(" + [[_listener errors] count] +
            " errors\0) and \0red(" + [[_listener failures] count] +
            " failures\0) and \0green(" + [[_listener successes] count] +
            " successes\0)\nTotal tests : " + totalTests);
        OS.exit(1);
    }
}

@end
