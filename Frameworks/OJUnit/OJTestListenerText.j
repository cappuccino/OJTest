@import <Foundation/Foundation.j>

@implementation OJTestListenerText : CPObject
{
    CPArray _errors;
    CPArray _failures;
}

- (id)init
{
    self = [super init];

    _errors = [];
    _failures = [];

    return self;
}

- (void)addError:(CPException)error forTest:(OJTest)aTest
{
    _errors.push(error);
    CPLog.error("addError  test="+[aTest description]+" error="+error);
}

- (CPArray)errors
{
    return _errors;
}

- (void)addFailure:(CPException)failure forTest:(OJTest)aTest
{
    _failures.push(failure);
    CPLog.warn("addFailure test="+[aTest description]+" failure="+failure);
}

- (CPArray)failures
{
    return _failures;
}

- (void)startTest:(OJTest)aTest
{
    CPLog.info("startTest  test="+[aTest description]);
}

- (void)endTest:(OJTest)aTest
{
    CPLog.info("endTest    test="+[aTest description]);
}

@end
