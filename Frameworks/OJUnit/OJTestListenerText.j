@import <Foundation/Foundation.j>

stream = require("term").stream;

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
    
    stream.print("\n\0red(addError test="+[aTest description]+" error="+anException+"\0)");
    var backTrace = getBacktrace(anException);
    if (backTrace) {
        CPLog.error(backTrace);
        stream.print(backTrace);
    }
}

- (CPArray)errors
{
    return _errors;
}

- (void)addFailure:(CPException)anException forTest:(OJTest)aTest
{
    _failures.push(anException);
    stream.print("\n\0yellow(addFailure test="+[aTest description]+" failure="+anException+"\0)");
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
