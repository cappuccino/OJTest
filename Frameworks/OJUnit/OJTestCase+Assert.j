@import "OJAssert.j"

@implementation OJTestCase (OJAssert)

/*!
   @group OJAssertions
   
   assert that the given condition is true
   
   @param condition The condition to verify
 */
- (void)assertTrue:(BOOL)condition
{
    [OJAssert assertTrue:condition];
}

/*!
   @group assertions
   
   assert that the given condition is true and if it is not report the given message
   
   @param condition The condition to verify
   @param message The failure message
 */
- (void)assertTrue:(BOOL)condition message:(CPString)message
{
	[OJAssert assertTrue:condition message:message];
}

/*!
   @group assertions
   
   assert that the given condition is false
   
   @param condition The condition to verify
 */
- (void)assertFalse:(BOOL)condition
{
    [OJAssert assertFalse:condition];
}

/*!
   @group assertions
   
   assert that the given condition is false and if not false then report the given message
   
   @param condition The condition to verify
   @param message The failure message
 */
- (void)assertFalse:(BOOL)condition message:(CPString)message
{
    [OJAssert assertFalse:condition message:message];
}

/*!
   @group assertions
   
   assert that the expected value is equal to the actual value
   
   @param expected The expected value
   @param actual The actual value
 */
- (void)assert:(id)expected equals:(id)actual
{
    [OJAssert assert:expected equals:actual];
}

/*!
   @group assertions
   
   assert that the expected value is equal to the actual value and not equal then report
   the given message
   
   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
- (void)assert:(id)expected equals:(id)actual message:(CPString)message
{
	[OJAssert assert:expected equals:actual message:message];
}

/*!
   @group assertions
   
   assert that the expected value is not equal to the actual value
   
   @param expected The expected value
   @param actual The actual value
 */
- (void)assert:(id)expected notEqual:(id)actual
{
    [OJAssert assert:expected notEqual:actual];
}

/*!
   @group assertions
   
   assert that the expected value is not equal to the actual value and if equal then report
   the given message
   
   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
- (void)assert:(id)expected notEqual:(id)actual message:(CPString)message
{
	[OJAssert assert:expected notEqual:actual message:message];
}

/*!
   @group assertions
   
   assert that the expected object and the actual object are the same object.
   
   @param expected The expected value
   @param actual The actual value
 */
- (void)assert:(id)expected same:(id)actual
{
    [OJAssert assert:expected same:actual];
}

/*!
   @group assertions
   
   assert that the expected object and the actual object are the same object. If they are
   different, then report the given message.
   
   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
- (void)assert:(id)expected same:(id)actual message:(CPString)message
{
	[OJAssert assert:expected same:actual message:message];
}

/*!
   @group assertions
   
   assert that the expected object and the actual object are not the same object.
   
   @param expected The expected value
   @param actual The actual value
 */
- (void)assert:(id)expected notSame:(id)actual
{
    [OJAssert assert:expected notSame:actual];
}

/*!
   @group assertions
   
   assert that the expected object and the actual object are not the same object. If they
   are the same, then report the given message.
   
   @param expected The expected value
   @param actual The actual value
   @param message The failure message
 */
- (void)assert:(id)expected notSame:(id)actual message:(CPString)message
{
	[OJAssert assert:expected notSame:actual message:message];
}

/*!
   @group assertions
   
   assert that the given object is null
   
   @param object The given object
 */
- (void)assertNull:(id)object
{
	[OJAssert assertNull:object];
}

/*!
   @group assertions
   
   assert that the given object is null. If it is not null, report the given message.
   
   @param a parameter
 */
- (void)assertNull:(id)object message:(CPString)message
{
	[OJAssert assertNull:object message:message];
}

/*!
   @group assertions
   
   assert that the given object is not null.
   
   @param object The given object
 */
- (void)assertNotNull:(id)object
{
    [OJAssert assertNotNull:object];
}

/*!
   @group assertions
   
   assert that the given object is not null. If it is null, report the given message.
   
   @param object The given object
   @param message The failure message
 */
- (void)assertNotNull:(id)object message:(CPString)message
{
	[OJAssert assertNotNull:object message:message];
}

/*!
   @group assertions
   
   assert that the zero argument closure that is given does not throw an exception.
   
   @param zeroArgClosure The zero argument closure that will be run.
   
        Example:
            
            [self assertNoThrow:function(){[myObject myMessage:myArgument];}];
 */
- (void)assertNoThrow:(Function)zeroArgClosure
{
	[OJAssert assertNoThrow:zeroArgClosure];
}

/*!
   @group assertions

   assert that the zero argument closure that is given does throw an exception.

   @param zeroArgClosure The zero argument closure that will be run.

        Example:

            [self assertThrows:function(){[myObject myMessage:myArgument];}];
 */
- (void)assertThrows:(Function)zeroArgClosure
{
	[OJAssert assertThrows:zeroArgClosure];
}

/*!
   @group assertions
   
   assert that the given Regular Expression matches the given string
   
   @param aRegex A string that represents a regular expression (e.g. @"^(.*)$")
   @param aString The string to test the regular expression against
 */
- (void)assert:(CPString)aRegex matches:(CPString)aString
{
	[OJAssert assert:aRegex matches:aString];
}

/*!
   @group assertions
   
   Fails the test case.
 */
- (void)fail
{
    [OJAssert fail:nil];
}

/*!
   @group assertions
   
   Fails the test case and reports the given message.
   
   @param message The failure message
 */
- (void)fail:(CPString)message
{
	[OJAssert fail:message];
}

- (void)failSame:(id)expected actual:(id)actual message:(CPString)message
{
	[OJAssert failSame:expected actual:actual message:message];
}

- (void)failNotSame:(id)expected actual:(id)actual message:(CPString)message
{
	[OJAssert failNotSame:expected actual:actual message:message];
}

- (void)failEqual:(id)expected actual:(id)actual message:(CPString)message
{
	[OJAssert failEqual:expected actual:actual message:message];
}

- (void)failNotEqual:(id)expected actual:(id)actual message:(CPString)message
{
	[OJAssert failNotEqual:expected actual:actual message:message];
}

@end