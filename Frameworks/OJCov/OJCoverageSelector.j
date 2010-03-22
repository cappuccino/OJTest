@import <Foundation/CPObject.j>

@implementation OJCoverageSelector : CPObject
{
    Class       klass           @accessors(readonly);
    SEL         selector        @accessors(readonly);
}

+ (id)selectorWithClassName:aClass selector:(SEL)aSelector
{
    return [[[self class] alloc] initWithClassName:aClass selector:aSelector];
}

+ (id)selectorWithObject:(id)anObject selector:(SEL)aSelector
{
    return [[[self class] alloc] initWithClassName:[anObject class] selector:aSelector];
}

- (id)initWithClassName:(CPString)aKlass selector:(SEL)aSelector
{
    self = [super init];
    if(self)
    {
        klass = aKlass;
        selector = aSelector;
    }
    return self;
}

- (BOOL)isEqual:(OJCoverageSelector)anotherSelector
{
    return klass == [anotherSelector klass] && [[self selector] isEqualToString:[anotherSelector selector]];
}

- (CPString)description
{
    return [CPString stringWithFormat:@"%@[%@]", klass, selector];
}

@end
