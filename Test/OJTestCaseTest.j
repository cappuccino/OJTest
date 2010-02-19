@import "../Framework/OJUnit/OJTestCase.j"

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



@end