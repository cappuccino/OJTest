@import "../Frameworks/OJUnit/OJTestRunnerTextParallel.j"

@implementation OJTestRunnerTextParallelTest : OJTestCase
{
    BOOL        wasCalled;
    BOOL        externalCall;
    id          caller;
}

- (void)setUp
{
    wasCalled = false;
    externalCall = false;
    caller = nil;
}

- (void)testThatOJTestRunnerTextParallelDoesInitialize
{
    [OJAssert assertNotNull:[[OJTestRunnerTextParallel alloc] init]];
}

- (void)testThatOJTreadDoesInitialize
{
    [OJAssert assertNotNull:[[OJThread alloc] initWithDelegate:nil]];
}

- (void)testThatOJThreadDoesRunSetFunction
{
    var result = false;
    var f = function() { result = true; };
    var target = [[OJThread alloc] initWithDelegate:nil];
    [target setStartFunction:f];
    
    [target start];
    
    var i = 0;
    while(i < 5000)  // heh.
        i++;
    
    [OJAssert assertTrue:result];
}

- (void)testThatOJThreadDoesAlertDelegateOfFinish
{
    var target = [[OJThread alloc] initWithDelegate:self];
    
    [target start];
    
    [OJAssert assertTrue:wasCalled];
}

- (void)testThatOJThreadDoesSendItself
{
    var target = [[OJThread alloc] initWithDelegate:self];
    
    [target start];
    
    [OJAssert assert:target equals:caller];
}

- (void)testThatOJThreadDoesHaveExternalCallCapabilities
{
    var f = function() { [self threadExternalCall]; };
    var target = [[OJThread alloc] initWithDelegate:self];
    [target setStartFunction:f];
    
    [target start];
    
    var i = 0;
    while(i < 5000)  // heh.
        i++;
    
    [OJAssert assertTrue:externalCall];
}

- (void)threadFinished:(id)aCaller
{
    wasCalled = true;
    caller = aCaller;
}

- (void)threadExternalCall
{
    externalCall = true;
}

@end