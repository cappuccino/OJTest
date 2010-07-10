@import "../Frameworks/OJUnit/OJTestCase.j"
@import "../Frameworks/OJUnit/OJAssert.j"

@implementation OJTestCaseTest : OJTestCase

- (void)testThatOJTestCaseDoesInitialize
{
   [OJAssert assertNotNull:[[OJTestCase alloc] init]];
}

@end

