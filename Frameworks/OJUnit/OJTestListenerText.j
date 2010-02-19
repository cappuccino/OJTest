@import <Foundation/Foundation.j>

function convertRhinoBacktrace(javaException) {
    var s = new Packages.java.io.StringWriter();
    javaException.printStackTrace(new Packages.java.io.PrintWriter(s));
    return String(s.toString()).split("\n").filter(function(s) { return (/^\s*at script/).test(s); }).join("\n");
}

function getBacktrace(e) {
    if (!e) {
        return "";
    }
    else if (e.rhinoException) {
        return convertRhinoBacktrace(e.rhinoException);
    }
    else if (e.javaException) {
        return convertRhinoBacktrace(e.javaException);
    }
    return "";
}

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

- (void)addError:(CPException)anException forTest:(OJTest)aTest
{
    _errors.push(anException);
    CPLog.error("addError  test="+[aTest description]+" error="+anException);
    var backTrace = getBacktrace(anException);
    if (backTrace)
        CPLog.error(backTrace);
}

- (CPArray)errors
{
    return _errors;
}

- (void)addFailure:(CPException)anException forTest:(OJTest)aTest
{
    _failures.push(anException);
    CPLog.warn("addFailure test="+[aTest description]+" failure="+anException);
    var backTrace = getBacktrace(anException);
    if (backTrace)
        CPLog.warn(backTrace);
}

- (CPArray)failures
{
    return _failures;
}

- (void)startTest:(OJTest)aTest
{
    system.stderr.write(".").flush();
    CPLog.info("startTest  test="+[aTest description]);
}

- (void)endTest:(OJTest)aTest
{
    CPLog.info("endTest    test="+[aTest description]);
}

@end
