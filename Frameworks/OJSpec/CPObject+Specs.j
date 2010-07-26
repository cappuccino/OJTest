@implementation CPObject (Specs)

+ (void)should:(CPString)specDescription by:(Function)specFn
{
	specFn(self);
}

+ (void)should:(CPString)specDescription
{
	[OJAssert fail:@"pending"];
}

@end

@import "Matchers/OJSpecShouldBeInstanceOf.j"
@import "Matchers/OJSpecShouldBeNil.j"
@import "Matchers/OJSpecShouldBeSameAs.j"
@import "Matchers/OJSpecShouldEqual.j"

