@import "../Frameworks/OJUnit/OJTestResult.j"
@import "../Frameworks/OJUnit/OJAssert.j"

@implementation OJTestResultTest : OJTestCase

- (void)testThatOJTestResultDoesInitialize
{
	[OJAssert assertNotNull:[[OJTestResult alloc] init]]
}

- (void)testThatOJTestCaseDoesCreateResult
{
	[OJAssert assertNotNull:[OJTestResult createResult]];
}

@end