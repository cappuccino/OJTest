@import <Foundation/CPObject.j>

@implementation OJMoqSpy : CPObject
{
	CPObject		_baseObject		@accessors(property=baseObject);
}

+ (OJMoqSpy)spyOnBaseObject:(id)baseObject
{
	return [[OJMoqSpy alloc] initWithBaseObject:baseObject];
}

- (id)init
{
	return [[OJMoqSpy alloc] initWithBaseObject:nil];
}

- (id)initWithBaseObject:(CPObject)baseObject
{
	if(self = [super init]) {
		_baseObject = baseObject;
	}
	return self;
}

@end
