@import <Foundation/Foundation.j>

function convertRhinoBacktrace(javaException) {
    var s = new Packages.java.io.StringWriter();
    javaException.printStackTrace(new Packages.java.io.PrintWriter(s));
    return String(s.toString()).split("\n").filter(function(s) { return (/^\s*at script/).test(s); }).join("\n");
}

function getBacktrace(e) {
    if (!e)
    {
        return "";
    }
    else if (e.rhinoException)
    {
        return convertRhinoBacktrace(e.rhinoException);
    }
    else if (e.javaException)
    {
        return convertRhinoBacktrace(e.javaException);
    }
    return "";
}

@implementation OJTestFailure : CPObject
{
    OJTest      _failedTest         @accessors(readonly, property=failedTest);
    CPException _thrownException    @accessors(readonly, property=thrownException);
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

- (CPString)description
{
    return [_failedTest description] + ": " + [self exceptionMessage];
}

- (CPString)trace
{
    return getBacktrace(_thrownException) ? getBacktrace(_thrownException) : "Trace not implemented";
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
