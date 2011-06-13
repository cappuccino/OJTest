@import "../Frameworks/OJUnit/OJAssert.j"

@implementation OJAssertTest : OJTestCase

- (void)testThatOJTestCaseAssertsTrue
{
    [OJAssert assertTrue:YES];
}

- (void)testThatOJTestCaseFailsOnAssertTrue
{
    [OJAssert assertThrows:function() {[OJAssert assertTrue:NO];}];
}

- (void)testThatOJTestCaseDoesAssertsNotEqual
{
    var objectOne = "A";
    var objectTwo = "B";
    
    [OJAssert assert:objectOne notEqual:objectTwo];
}

- (void)testThatOJTestCaseDoesAssertsNotEqualWithMessage
{
    var objectOne = "A";
    var objectTwo = "B";

    [OJAssert assert:objectOne notEqual:objectTwo message:@"Object one should have not equaled object two!"];
}

- (void)testThatOJTestCaseDoesFailOnAssertNotEqualWhenObjectsEqual
{
    var objectOne = "A";
    var objectTwo = "A";
    
    [OJAssert assertThrows:function(){[OJAssert assert:objectOne notEqual:objectTwo]}];
}

- (void)testThatOJTestCaseAssertsNull
{
    [OJAssert assertNoThrow:function(){[OJAssert assertNull:nil]}];
}

- (void)testThatOJTestCaseFailNotSameHandlesNullInputCorrectly
{
    try
    {
        [OJAssert failNotSame:null actual:null message:null];
    }
    catch (e)
    {
        [OJAssert assert:@"expected same:<null> was not:<null>" equals:e.message
             message:@"failNotSame did not handle null input correctly"];
    }
}

- (void)testThatOJTestCaseFailEqualHandlesNullInputCorrectly
{
    try
    {
        [OJAssert failEqual:null actual:null message:null];
    }
    catch (e)
    {
        [OJAssert assert:@"expected inequality. Expected:<null> Got:<null>" equals:e.message
             message:@"failEqual did not handle null input correctly"];
    }
}

- (void)testThatOJTestCaseFailNotEqualHandlesNullInputCorrectly
{
    try
    {
        [OJAssert failNotEqual:null actual:null message:null];
    }
    catch (e)
    {
        [OJAssert assert:@"expected:<null> but was:<null>" equals:e.message
             message:@"failNotEqual did not handle null input correctly"];
    }
}

- (void)testThatOJTestCaseMatchedRegex
{
  var longStringWithComlicatedInput = "abc123ABC";

  [OJAssert assertNoThrow:function () {
    [OJAssert assert:"\\d+AB" matches:longStringWithComlicatedInput];
  }];
}

- (void)testThatOJTestCaseDoesNotMatchRegex
{
  var longStringWithComlicatedInput = "abc123ABC";

  [OJAssert assertThrows:function () {
    [OJAssert assert:"\d+ABc" matches:longStringWithComlicatedInput];
  }];
}

@end
