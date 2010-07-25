@import "../OJSpecMatcher.j"

@implementation OJSpecShouldBeNil : OJSpecMatcher

@end


/**
 * Checks if an object is nil.
 */
@implementation CPObject (ShouldBeNilMatcher)

- (void)shouldBeNil
{
    [[[OJSpecShouldBeNil alloc] initWithExpected:nil] matches:self];
}

- (void)shouldNotBeNil
{
    [[[OJSpecShouldBeNil alloc] initWithExpected:nil] doesNotMatch:self];
}

@end