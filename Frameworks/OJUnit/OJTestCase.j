@import <Foundation/Foundation.j>

@import "OJTestResult.j"

AssertionFailedError = "AssertionFailedError";

@implementation OJTestCase : CPObject
{
    SEL _selector;
}

- (OJTestResult)createResult
{
    return [[OJTestResult alloc] init];
}

- (OJTestResult)run
{
    var result = [self createResult];
    [self run:result];
    return result;
}

- (void)run:(OJTestResult)result
{
    [result run:self];
}

- (void)runBare
{
    [self setUp];
    try
    {
        [self runTest];
    }
    finally
    {
        [self tearDown];
    }
}

- (void)runTest
{
    [self assertNotNull:_selector];
    
    [self performSelector:_selector];
}

- (void)setUp
{
}

- (void)tearDown
{
}

- (SEL)selector
{
    return _selector;
}

- (void)setSelector:(SEL)aSelector
{
    _selector = aSelector;
}

- (int)countTestCases
{
    return 1;
}

- (void)assertTrue:(BOOL)condition
{
    [self assertTrue:condition message:"expected YES but got NO"];
}

- (void)assertTrue:(BOOL)condition message:(CPString)message
{
    if (!condition)
        [self fail:message];
}

- (void)assertFalse:(BOOL)condition
{
    [self assertFalse:condition message:"expected NO but got YES"];
}

- (void)assertFalse:(BOOL)condition message:(CPString)message
{
    [self assertTrue:(!condition) message:message];
}

- (void)assert:(id)expected equals:(id)actual
{
    [self assert:expected equals:actual message:nil];
}

- (void)assert:(id)expected equals:(id)actual message:(CPString)message
{
    if (expected !== actual && ![expected isEqual:actual])
        [self failNotEqual:expected actual:actual message:message];
}

- (void)assert:(id)expected notEqual:(id)actual
{
    [self assert:expected notEqual:actual message:nil];
}

- (void)assert:(id)expected notEqual:(id)actual message:(CPString)message
{
    if (expected === actual || [expected isEqual:actual])
        [self failEqual:expected actual:actual message:message];
}

- (void)assert:(id)expected same:(id)actual
{
    [self assert:expected same:actual message:nil];
}

- (void)assert:(id)expected same:(id)actual message:(CPString)message
{
    if (expected !== actual)
        [self failSame:expected actual:actual message:message];
}

- (void)assert:(id)expected notSame:(id)actual
{
    [self assert:expected notSame:actual message:nil];
}

- (void)assert:(id)expected notSame:(id)actual message:(CPString)message
{
    if (expected === actual)
        [self failNotSame:expected actual:actual message:message];
}

- (void)assertNull:(id)object
{
    [self assertNull:object message:"expected null but got " + object];
}

- (void)assertNull:(id)object message:(CPString)message
{
    [self assertTrue:(object === null) message:message];
}

- (void)assertNotNull:(id)object
{
    [self assertNotNull:object message:"expected an object but got null"];
}

- (void)assertNotNull:(id)object message:(CPString)message
{
    [self assertTrue:(object !== null) message:message];
}

- (void)assertNoThrow:(Function)zeroArgClosure
{
    var exception = nil;
    try { zeroArgClosure(); }
    catch (e) { exception = e; }
    [self assertNull:exception message:"Caught unexpected exception " + exception];
}

- (void)assertThrows:(Function)zeroArgClosure
{
    var exception = nil;
    try { zeroArgClosure(); }
    catch (e) { exception = e; }
    [self assertNotNull:exception message:"Should have cought an exception, but got nothing"];
}

- (void)assert:(CPString)aRegex matches:(CPString)aString
{
    [self assertTrue:aString.match(RegExp(aRegex))
        message:"string '" + aString + "' should be matched by regex /" + aRegex + "/"];
}

- (void)fail
{
    [self fail:nil];
}

- (void)fail:(CPString)message
{
    [CPException raise:AssertionFailedError reason:(message || "Unknown")];
}

- (void)failSame:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message+" " : "")+"expected not same")];
}

- (void)failNotSame:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message+" " : "")+"expected same:<"+expected+"> was not:<"+actual+">")];
}

- (void)failEqual:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message+" " : "")+"expected inequality. Expected:<"+expected+"> Got:<"+actual+">")];
}

- (void)failNotEqual:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message+" " : "")+"expected:<"+expected+"> but was:<"+actual+">")];
}

- (CPString)description
{
    return "[" + [self className] + " " + _selector + "]";
}

@end

