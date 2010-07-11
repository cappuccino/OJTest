@import "../Frameworks/OJUnit/OJTestResult.j"
@import "../Frameworks/OJUnit/OJAssert.j"
@import "../Frameworks/OJMoq/OJMoq.j"

@implementation OJTestResultTest : OJTestCase
{
	OJTestResult		target;
}

- (void)setUp
{
	target = [OJTestResult createResult];
}

- (void)testThatOJTestResultDoesInitialize
{
	[OJAssert assertNotNull:[[OJTestResult alloc] init]]
}

- (void)testThatOJTestResultDoesCreateResult
{
	[OJAssert assertNotNull:[OJTestResult createResult]];
}

- (void)testThatOJTestResultIsSuccessfulWithNoErrorsOrFailures
{
	[OJAssert assertTrue:[target wasSuccessful]];
}

- (void)testThatOJTestResultDoesHaveZeroErrorsAndZeroFailures
{
	[OJAssert assert:0 equals:[target failureCount]];
	[OJAssert assert:0 equals:[target errorCount]];
}

- (void)testThatOJTestResultShouldStop
{
	[OJAssert assertFalse:[target shouldStop]];
	
	[target stop];
	
	[OJAssert assertTrue:[target shouldStop]];
}

- (void)testThatOJTestResultDoesAddError
{
	[target addError:[[CPException alloc] init] forTest:[[OJTestCase alloc] init]];
	[OJAssert assertFalse:[target wasSuccessful]];
	[OJAssert assert:1 equals:[target errorCount]];
}

- (void)testThatOJTestResultDoesAddFailure
{
	[target addFailure:[[CPException alloc] init] forTest:[[OJTestCase alloc] init]];
	[OJAssert assertFalse:[target wasSuccessful]];
	[OJAssert assert:1 equals:[target failureCount]];
}

- (void)testThatOJTestResultDoesIncreaseRunCount
{
	[target run:[[OJTestCase alloc] init]];
	
	[OJAssert assert:1 equals:[target runCount]];
}

- (void)testThatOJTestResultDoesIncreaseRunCountTwice
{
	[target run:[[OJTestCase alloc] init]];
	[target run:[[OJTestCase alloc] init]];

	[OJAssert assert:2 equals:[target runCount]];
}

@end