@import "../Frameworks/OJUnit/OJTestCase.j"

@implementation OJTestCaseTest : OJTestCase

- (void)testThatOJTestCaseDoesInitialize
{
    [self assertNotNull:[[OJTestCase alloc] init]];
}

- (void)testThatOJTestCaseAssertsTrue
{
    var target = [[OJTestCase alloc] init];
    
    [target assertTrue:YES];
}

- (void)testThatOJTestCaseFailsOnAssertTrue
{
    var target = [[OJTestCase alloc] init];
    
    [self assertThrows:function() {[target assertTrue:NO];}];
}

- (void)testThatOJTestCaseDoesAssertsNotEqual
{
    var target = [[OJTestCase alloc] init];
    var objectOne = "A";
    var objectTwo = "B";
    
    [target assert:objectOne notEqual:objectTwo];
}

- (void)testThatOJTestCaseDoesAssertsNotEqualWithMessage
{
    var target = [[OJTestCase alloc] init];
    var objectOne = "A";
    var objectTwo = "B";

    [target assert:objectOne notEqual:objectTwo message:@"Object one should have not equaled object two!"];
}


- (void)testThatOJTestCaseDoesFailOnAssertNotEqualWhenObjectsEqual
{
    var target = [[OJTestCase alloc] init];
    var objectOne = "A";
    var objectTwo = "A";
    
    [self assertThrows:function(){[target assert:objectOne notEqual:objectTwo]}];
}

- (void)testThatOJTestCaseAssertsNull
{
    var target = [[OJTestCase alloc] init];
    var objectOne = nil;

    [self assertNoThrow:function(){[target assertNull:objectOne]}];
}

- (void)testThatOJTestCaseFailNotSameHandlesNullInputCorrectly
{
    var target = [[OJTestCase alloc] init];

    try
    {
        [target failNotSame:null actual:null message:null];
    }
    catch (e)
    {
        [self assert:@"expected same:<null> was not:<null>" equals:e.message
             message:@"failNotSame did not handle null input correctly"];
    }
}

- (void)testThatOJTestCaseFailEqualHandlesNullInputCorrectly
{
    var target = [[OJTestCase alloc] init];

    try
    {
        [target failEqual:null actual:null message:null];
    }
    catch (e)
    {
        [self assert:@"expected inequality. Expected:<null> Got:<null>" equals:e.message
             message:@"failEqual did not handle null input correctly"];
    }
}

- (void)testThatOJTestCaseFailNotEqualHandlesNullInputCorrectly
{
    var target = [[OJTestCase alloc] init];

    try
    {
        [target failNotEqual:null actual:null message:null];
    }
    catch (e)
    {
        [self assert:@"expected:<null> but was:<null>" equals:e.message
             message:@"failNotEqual did not handle null input correctly"];
    }
}

@end

