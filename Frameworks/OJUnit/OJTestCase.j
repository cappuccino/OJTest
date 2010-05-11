@import <Foundation/Foundation.j>

@import "OJTestResult.j"

AssertionFailedError = "AssertionFailedError";

/*!
    A single test case. This is an abstract superclass that each of your test cases (which are
    usually in their own separate files and of which each tests one and only one class) should
    subclass. Each of these test cases have the ability to run seperately.
   
    Example:
   
        @implementation OJMoqTest : OJTestCase
        
        ... // tests and other files
        
        @end
        
    In order to increase readability, there is a conventional way of writing tests. Each test
    should be prepended by the word "test" and non-tests should not be prepended by the word
    "test".
    
    Example:
    
        - (void)testThatOJMoqDoesInitialize {} // a test
        - (OJMoq)createStandardOJMoqInstance {return nil;} // a non-test
        
    Before each test, the message "setUp" will be passed to your test. By default, this does
    nothing but you can override the "setUp" method to do something for your test.
    
    After each test, the message "tearDown" will be passed to your test. By default, this
    does nothing but you can override the "tearDown" method to do something for your test.

    @brief A single test case.
 */
@implementation OJTestCase : CPObject
{
    SEL _selector;
}

/*!
   Factory method for creating the OJTestResult
 */
- (OJTestResult)createResult
{
    return [[OJTestResult alloc] init];
}

/*!
   Runs the tests and returns the result.
 */
- (OJTestResult)run
{
    var result = [self createResult];
    [self run:result];
    return result;
}

/*!
   Informs the OJTestResult to run the tests
   @param result The OJTestResult that will run the tests
 */
- (void)run:(OJTestResult)result
{
    [result run:self];
}

/*!
   Runs the setup, test and teardown for the 
   @param a parameter
 */
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

/*!
   If the selector is not null, 
   @param a parameter
 */
- (void)runTest
{
    [self assertNotNull:_selector];
    
    [self performSelector:_selector];
}

/*!
   SetUp method that is called before each run.
 */
- (void)setUp
{
}

/*!
   TearDown method that is called after each run.
 */
- (void)tearDown
{
}

/*!
   The selector for this test
 */
- (SEL)selector
{
    return _selector;
}

/*!
   Set the selector for this test
 */
- (void)setSelector:(SEL)aSelector
{
    _selector = aSelector;
}

/*!
   The number of test cases this represents.

    @returns 1
 */
- (int)countTestCases
{
    return 1;
}

/*!
   @group Assertions
   
   Assert that the given condition is true
   
   @param condition The condition to verify
 */
- (void)assertTrue:(BOOL)condition
{
    [self assertTrue:condition message:"expected YES but got NO"];
}

/*!
   @group Assertions
   
   Assert that the given condition is true and if it is not report the given message
   
   @param condition The condition to verify
   @param message The failure message
 */
- (void)assertTrue:(BOOL)condition message:(CPString)message
{
    if (!condition)
        [self fail:message];
}

/*!
   @group Assertions
   
   Assert that the given condition is false
   
   @param condition The condition to verify
 */
- (void)assertFalse:(BOOL)condition
{
    [self assertFalse:condition message:"expected NO but got YES"];
}

/*!
   @group Assertions
   
   Assert that the given condition is false and if not false then report the given message
   
   @param condition The condition to verify
   @param message The failure message
 */
- (void)assertFalse:(BOOL)condition message:(CPString)message
{
    [self assertTrue:(!condition) message:message];
}

/*!
   @group Assertions
   
   Assert that the expected value is equal to the actual value
   
   @param expected The expected value
   @param actual The actual value
 */
- (void)assert:(id)expected equals:(id)actual
{
    [self assert:expected equals:actual message:nil];
}

/*!
   @group Assertions
   
   Assert that the expected value is equal to the actual value and not equal then report
   the given message
   
   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
- (void)assert:(id)expected equals:(id)actual message:(CPString)message
{
    if (expected !== actual && ![expected isEqual:actual])
        [self failNotEqual:expected actual:actual message:message];
}

/*!
   @group Assertions
   
   Assert that the expected value is not equal to the actual value
   
   @param expected The expected value
   @param actual The actual value
 */
- (void)assert:(id)expected notEqual:(id)actual
{
    [self assert:expected notEqual:actual message:nil];
}

/*!
   @group Assertions
   
   Assert that the expected value is not equal to the actual value and if equal then report
   the given message
   
   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
- (void)assert:(id)expected notEqual:(id)actual message:(CPString)message
{
    if (expected === actual || [expected isEqual:actual])
        [self failEqual:expected actual:actual message:message];
}

/*!
   @group Assertions
   
   Assert that the expected object and the actual object are the same object.
   
   @param expected The expected value
   @param actual The actual value
 */
- (void)assert:(id)expected same:(id)actual
{
    [self assert:expected same:actual message:nil];
}

/*!
   @group Assertions
   
   Assert that the expected object and the actual object are the same object. If they are
   different, then report the given message.
   
   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
- (void)assert:(id)expected same:(id)actual message:(CPString)message
{
    if (expected !== actual)
        [self failSame:expected actual:actual message:message];
}

/*!
   @group Assertions
   
   Assert that the expected object and the actual object are not the same object.
   
   @param expected The expected value
   @param actual The actual value
 */
- (void)assert:(id)expected notSame:(id)actual
{
    [self assert:expected notSame:actual message:nil];
}

/*!
   @group Assertions
   
   Assert that the expected object and the actual object are not the same object. If they
   are the same, then report the given message.
   
   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
- (void)assert:(id)expected notSame:(id)actual message:(CPString)message
{
    if (expected === actual)
        [self failNotSame:expected actual:actual message:message];
}

/*!
   @group Assertions
   
   Assert that the given object is null
   
   @param object The given object
 */
- (void)assertNull:(id)object
{
    [self assertNull:object message:"expected null but got " + stringValueOf(object)];
}

/*!
   @group Assertions
   
   Assert that the given object is null. If it is not null, report the given message.
   
   @param a parameter
 */
- (void)assertNull:(id)object message:(CPString)message
{
    [self assertTrue:(object === null) message:message];
}

/*!
   @group Assertions
   
   Assert that the given object is not null.
   
   @param object The given object
 */
- (void)assertNotNull:(id)object
{
    [self assertNotNull:object message:"expected an object but got null"];
}

/*!
   @group Assertions
   
   Assert that the given object is not null. If it is null, report the given message.
   
   @param object The given object
   @param message The failure message
 */
- (void)assertNotNull:(id)object message:(CPString)message
{
    [self assertTrue:(object !== null) message:message];
}

/*!
   @group Assertions
   
   Assert that the zero argument closure that is given does not throw an exception.
   
   @param zeroArgClosure The zero argument closure that will be run.
   
        Example:
            
            [self assertNoThrow:function(){[myObject myMessage:myArgument];}];
 */
- (void)assertNoThrow:(Function)zeroArgClosure
{
    var exception = nil;
    try { zeroArgClosure(); }
    catch (e) { exception = e; }
    [self assertNull:exception message:"Caught unexpected exception " + exception];
}

/*!
   @group Assertions

   Assert that the zero argument closure that is given does throw an exception.

   @param zeroArgClosure The zero argument closure that will be run.

        Example:

            [self assertThrows:function(){[myObject myMessage:myArgument];}];
 */
- (void)assertThrows:(Function)zeroArgClosure
{
    var exception = nil;
    try { zeroArgClosure(); }
    catch (e) { exception = e; }
    [self assertNotNull:exception message:"Should have caught an exception, but got nothing"];
}

/*!
   @group Assertions
   
   Assert that the given Regular Expression matches the given string
   
   @param aRegex A string that represents a regular expression (e.g. @"^(.*)$")
   @param aString The string to test the regular expression against
 */
- (void)assert:(CPString)aRegex matches:(CPString)aString
{
    [self assertTrue:aString.match(RegExp(aRegex))
        message:"string '" + aString + "' should be matched by regex /" + aRegex + "/"];
}

/*!
   @group Assertions
   
   Fails the test case.
 */
- (void)fail
{
    [self fail:nil];
}

/*!
   @group Assertions
   
   Fails the test case and reports the given message.
   
   @param message The failure message
 */
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
    [self fail:((message ? message+" " : "")+"expected same:<"+stringValueOf(expected)+
        "> was not:<"+stringValueOf(actual)+">")];
}

- (void)failEqual:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message+" " : "")+"expected inequality. Expected:<"+stringValueOf(expected)+
        "> Got:<"+stringValueOf(actual)+">")];
}

- (void)failNotEqual:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message+" " : "")+"expected:<"+stringValueOf(expected)+
        "> but was:<"+stringValueOf(actual)+">")];
}

- (CPString)description
{
    return "[" + [self className] + " " + _selector + "]";
}

@end

function stringValueOf(obj) {
    if(obj && obj.isa)
        var result = [obj description];
    else
        var result = obj;
        
    return result;
}
