@import "../OJSpecMatcher.j"

@implementation OJSpecShouldBeNil : OJSpecMatcher
{
}

@end


/**
 * Checks if an object is nil.
 */
@implementation CPObject (ShouldBeNilMatcher)

- (void)shouldBeNil
{
    if(![[[OJSpecShouldBeNil alloc] initWithExpected:nil] matches:self])
        throw SpecFailedException;
}

- (void)shouldNotBeNil
{
    if([[[OJSpecShouldBeNil alloc] initWithExpected:nil] matches:self])
        throw SpecFailedException;
}

@end