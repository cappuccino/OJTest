@import <Foundation/Foundation.j>

stream = ObjectiveJ.term.stream;

@implementation OJTestListenerText : CPObject
{
    CPArray _errors;
    CPArray _failures;
    CPArray _successes;
}

- (id)init
{
    self = [super init];

    _errors = [];
    _failures = [];
    _successes = [];

    return self;
}

- (void)addError:(CPException)anException forTest:(OJTest)aTest
{
    CPLog.warn("[OJTestListenerText addError:forTest:] is deprecated. Please use [OJTestListener addError:].");
    [self addError:[[OJTestFailure alloc] initWithTest:aTest exception:anException]];
}

- (void)addError:(OJTestFailure)error
{
    _errors.push(error);

    stream.print("\n\0red(addError test="+[error description]+"\0)");
    stream.print("\n\0red("+[error trace]+"\0)");
}

- (CPArray)errors
{
    return _errors;
}

- (void)addFailure:(CPException)anException forTest:(OJTest)aTest
{
    CPLog.warn("[OJTestListenerText addFailure:forTest:] is deprecated. Please use [OJTestListener addFailure:].");
    [self addFailure:[[OJTestFailure alloc] initWithTest:aTest exception:anException]];
}

- (void)addFailure:(OJTestFailure)failure
{
    _failures.push(failure);

    stream.print("\n\0yellow(addFailure test=" + [failure description] + "\0)");
    stream.print("\n\0yellow(" + [failure trace] + "\0)");
}

- (CPArray)failures
{
    return _failures;
}

- (void)addSuccesTest:(OJTest)aTest
{
    _successes.push(aTest);
}

- (CPArray)successes
{
    return _successes;
}

- (void)startTest:(OJTest)aTest
{
    process.stderr.write(".");
    CPLog.info("startTest  test=" + [aTest description]);
}

- (void)endTest:(OJTest)aTest
{
    CPLog.info("endTest    test=" + [aTest description]);
}

@end
