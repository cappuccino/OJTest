@import "../Frameworks/OJUnit/OJTestFailure.j"
@import "../Frameworks/OJUnit/OJAssert.j"

@implementation OJTestFailureTest : OJTestCase
{
	OJTestFailure		target;
	OJTestCase			test;
	CPException			failure;
}

- (void)setUp
{
	test = [[OJTestCase alloc] init];
	failure = [[CPException alloc] init];
	target = [[OJTestFailure alloc] initWithTest:test exception:failure];
}

- (void)testThatOJTestFailureDoesInitialize
{
	[OJAssert assertNotNull:target];
}

- (void)testThatOJTestFailureDoesHaveDescription
{
	[test setSelector:@selector(test)];
	[OJAssert assert:@"[OJTestCase test]: Unknown error" equals:[target description]];
}

- (void)testThatOJTestFailureDoesReturnNoTraceWhenNoneAvailable
{
	[OJAssert assert:@"Trace not implemented" equals:[target trace]];
}

- (void)testThatOJTestFailureDoesReturnExceptionsMessage
{
	[OJAssert assert:[failure description] equals:[target exceptionMessage]];
}

- (void)testThatOJTestFailureDoesDetectIfItsNotAFailure
{
	[OJAssert assertFalse:[target isFailure]];
}

- (void)testThatOJTestFailureDoesDetectIfItsAFailure
{
	failure.name = AssertionFailedError;
	[OJAssert assertTrue:[target isFailure]];
}

@end