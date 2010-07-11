@import <Foundation/Foundation.j>

@import "OJTestFailure.j"

@implementation OJTestResult : CPObject
{
    CPArray     _failures		@accessors(readonly, property=failures);
    CPArray     _errors			@accessors(readonly, property=errors);
    CPArray     _listeners;
    int         _runTests;
    BOOL        _stop;
}

/*!
   Factory method for creating the OJTestResult
 */
+ (OJTestResult)createResult
{
    return [[OJTestResult alloc] init];
}

- (id)init
{
    if (self = [super init])
    {
        _failures   = [];
        _errors     = [];
        _listeners  = [];
        _runTests   = 0;
        _stop       = NO;
    }
    return self;
}

- (void)addError:(CPException)error forTest:(OJTest)aTest
{
    [_errors addObject:[[OJTestFailure alloc] initWithTest:aTest exception:error]];
    for (var i = 0; i < _listeners.length; i++)
        [_listeners[i] addError:error forTest:aTest];
}

- (void)addFailure:(CPException)failure forTest:(OJTest)aTest
{
    [_failures addObject:[[OJTestFailure alloc] initWithTest:aTest exception:failure]];
    for (var i = 0; i < _listeners.length; i++)
        [_listeners[i] addFailure:failure forTest:aTest];
}

- (void)startTest:(OJTest)aTest
{
    _runTests += [aTest countTestCases];
    for (var i = 0; i < _listeners.length; i++)
        [_listeners[i] startTest:aTest];
}

- (void)endTest:(OJTest)aTest
{
    
    for (var i = 0; i < _listeners.length; i++)
        [_listeners[i] endTest:aTest];
}

- (void)run:(OJTestCase)aTest
{
    [self startTest:aTest];

    try
    {
        [aTest runBare];
    }
    catch (e)
    {
        // if not objj object, toll-free bridge to CPException
        if (!e.isa) {
            CPLog.warn("toll-free bridging e="+e+" to CPException")
            e.isa = CPException;
        }

        if ([e name] == AssertionFailedError)
            [self addFailure:e forTest:aTest];
        else
            [self addError:e forTest:aTest];
    }

    [self endTest:aTest];
}

- (void)addListener:(OJTestListener)listener
{
    [_listeners addObject:listener];
}

- (void)removeListener:(OJTestListener)listener
{
    [_listeners removeObject:listener];
}

- (int)runCount
{
    return _runTests;
}

- (BOOL)shouldStop
{
    return _stop;
}

- (void)stop
{
    _stop = YES;
}

- (int)numberOfFailures
{
    return [_failures count];
}

- (int)failureCount
{
	CPLog.warn("[OJTestResult failureCount] is deprecated. Please use [OJTestResult numberOfFailures].");
	return [self numberOfFailures];
}

- (int)numberOfErrors
{
    return [_errors count];
}

- (int)errorCount
{
	CPLog.warn("[OJTestResult errorCount] is deprecated. Please use [OJTestResult numberOfErrors].");
	return [self numberOfErrors];
}

- (BOOL)wasSuccessful
{
    return [self numberOfFailures] == 0 && [self numberOfErrors] == 0;
}

@end