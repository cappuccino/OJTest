@import <Foundation/Foundation.j>

@implementation OJTestFailure : CPObject
{
    OJTest      _failedTest;
    CPException _thrownException;
}

- (id)initWithTest:(OJTest)failedTest exception:(CPException)thrownException
{
    if (self = [super init])
    {
        _failedTest = failedTest;
        _thrownException = thrownException;
    }
    return self;
}

- (OJTest)failedTest
{
    return _failedTest;
}

- (CPException)thrownException
{
    return _thrownException;
}

- (CPString)description
{
    return [_failedTest description] + ": " + [_thrownException description];
}

- (CPString)trace
{
    return "Trace not implemented";
}

- (CPString)exceptionMessage
{
    return [_thrownException description];
}

- (BOOL)isFailure
{
    return [_thrownException name] == AssertionFailedError; // should AssertionFailedError be a subclass of CPException?
}

@end