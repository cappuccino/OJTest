@import <Foundation/CPObject.j>

AssertionFailedError = @"AssertionFailedError";

@implementation OJAssert : CPObject

/*!
   Assert that the given condition is true

   @param condition The condition to verify
 */
+ (void)assertTrue:(BOOL)condition
{
    [self assertTrue:condition message:"expected YES but got NO"];
}

/*!
   Assert that the given condition is true and if it is not report the given message

   @param condition The condition to verify
   @param message The failure message
 */
+ (void)assertTrue:(BOOL)condition message:(CPString)message
{
    if (!condition)
        [self fail:message];
}

/*!
   Assert that the given condition is false

   @param condition The condition to verify
 */
+ (void)assertFalse:(BOOL)condition
{
    [self assertFalse:condition message:"expected NO but got YES"];
}

/*!
   Assert that the given condition is false and if not false then report the given message

   @param condition The condition to verify
   @param message The failure message
 */
+ (void)assertFalse:(BOOL)condition message:(CPString)message
{
    [self assertTrue:(!condition) message:message];
}

/*!
   Assert that the expected value is equal to the actual value

   @param expected The expected value
   @param actual The actual value
 */
+ (void)assert:(id)expected equals:(id)actual
{
    [self assert:expected equals:actual message:nil];
}

/*!
   Assert that the expected value is equal to the actual value and not equal then report
   the given message

   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
+ (void)assert:(id)expected equals:(id)actual message:(CPString)message
{
    if (expected !== actual && ![expected isEqual:actual])
        [self failNotEqual:expected actual:actual message:message];
}

/*!
   Assert that the expected value is not equal to the actual value

   @param expected The expected value
   @param actual The actual value
 */
+ (void)assert:(id)expected notEqual:(id)actual
{
    [self assert:expected notEqual:actual message:nil];
}

/*!
   Assert that the expected value is not equal to the actual value and if equal then report
   the given message

   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
+ (void)assert:(id)expected notEqual:(id)actual message:(CPString)message
{
    if (expected === actual || [expected isEqual:actual])
        [self failEqual:expected actual:actual message:message];
}

/*!
   Assert that the expected object and the actual object are the same object.

   @param expected The expected value
   @param actual The actual value
 */
+ (void)assert:(id)expected same:(id)actual
{
    [self assert:expected same:actual message:nil];
}

/*!
   Assert that the expected object and the actual object are the same object. If they are
   different, then report the given message.

   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
+ (void)assert:(id)expected same:(id)actual message:(CPString)message
{
    if (expected !== actual)
        [self failSame:expected actual:actual message:message];
}

/*!
   Assert that the expected object and the actual object are not the same object.

   @param expected The expected value
   @param actual The actual value
 */
+ (void)assert:(id)expected notSame:(id)actual
{
    [self assert:expected notSame:actual message:nil];
}

/*!
   Assert that the expected object and the actual object are not the same object. If they
   are the same, then report the given message.

   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
+ (void)assert:(id)expected notSame:(id)actual message:(CPString)message
{
    if (expected === actual)
        [self failNotSame:expected actual:actual message:message];
}

/*!
   Assert that the given object is null

   @param object The given object
 */
+ (void)assertNull:(id)object
{
    [self assertNull:object message:"expected null but got " + stringValueOf(object)];
}

/*!
   Assert that the given object is null. If it is not null, report the given message.

   @param a parameter
 */
+ (void)assertNull:(id)object message:(CPString)message
{
    [self assertTrue:(object === null) message:message];
}

/*!
   Assert that the given object is not null.

   @param object The given object
 */
+ (void)assertNotNull:(id)object
{
    [self assertNotNull:object message:"expected an object but got null"];
}

/*!
   Assert that the given object is not null. If it is null, report the given message.

   @param object The given object
   @param message The failure message
 */
+ (void)assertNotNull:(id)object message:(CPString)message
{
    [self assertTrue:(object !== null) message:message];
}

/*!
   Assert that the zero argument closure that is given does not throw an exception.

   @param zeroArgClosure The zero argument closure that will be run.

        Example:

            [self assertNoThrow:function(){[myObject myMessage:myArgument];}];
 */
+ (id)assertNoThrow:(Function)zeroArgClosure
{
    var result = nil;
    var exception = nil;
    try { result = zeroArgClosure(); }
    catch (e) { exception = e; }
    [self assertNull:exception message:"Caught unexpected exception " + exception];
    return result;
}

/*!
   Assert that the zero argument closure that is given does throw an exception.

   @param zeroArgClosure The zero argument closure that will be run.

        Example:

            [self assertThrows:function(){[myObject myMessage:myArgument];}];
 */
+ (id)assertThrows:(Function)zeroArgClosure
{
    var result = nil;
    var exception = nil;
    try { result = zeroArgClosure(); }
    catch (e) { result = exception = e; }
    [self assertNotNull:exception message:"Should have caught an exception, but got nothing"];
    return result;
}

/*!
   Assert that the given Regular Expression matches the given string.
   The regular expression should be passed as a double escaped string.
   For example, testing one or more digits is [OJAssert assert:"\\d+" equals:"123"];

   @param aRegex A string that represents a regular expression (e.g. @"^(\\.*)$")
   @param aString The string to test the regular expression against
 */
+ (void)assert:(CPString)aRegex matches:(CPString)aString
{
    [self assertTrue:aString.match(RegExp(aRegex))
        message:"string '" + aString + "' should be matched by regex /" + aRegex + "/"];
}

/*!
   Fails the test case.
 */
+ (void)fail
{
    [self fail:nil];
}

/*!
   Fails the test case and reports the given message.

   @param message The failure message
 */
+ (void)fail:(CPString)message
{
    [CPException raise:AssertionFailedError reason:(message || "Unknown")];
}

+ (void)failSame:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message + " " : "") + "expected not same")];
}

+ (void)failNotSame:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message + " " : "") + "expected same:<" + stringValueOf(expected)+
        "> was not:<" + stringValueOf(actual) + ">")];
}

+ (void)failEqual:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message + " " : "") + "expected inequality. Expected:<" + stringValueOf(expected) +
        "> Got:<" + stringValueOf(actual) + ">")];
}

+ (void)failNotEqual:(id)expected actual:(id)actual message:(CPString)message
{
    [self fail:((message ? message + " " : "") + "expected:<" + stringValueOf(expected) +
        "> but was:<" + stringValueOf(actual) + ">")];
}

@end

function stringValueOf(obj) {
    if (obj && obj.isa)
        var result = [obj description];
    else
        var result = obj;

    return result;
}
