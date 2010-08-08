@import "../Frameworks/OJMoq/OJMoqStub.j"

@implementation OJMoqStubTest : OJTestCase

- (void)testThatOJMoqStubDoesInitialize
{
	[OJAssert assertNotNull:stub()];
}

- (void)testThatOJMoqStubDoesAcceptAnything
{
	var target = stub();
	
	[target doSomething];
	[target doSomethingElse:@"Bob"];
	
	[OJAssert assertTrue:YES];
}

- (void)testThatOJMoqStubDoesReturnVoid
{
	var target = stub();
	
	var result = [target doSomething];
	
	[OJAssert assertNull:result];
}

@end