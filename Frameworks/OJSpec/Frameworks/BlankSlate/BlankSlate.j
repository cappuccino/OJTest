@import <Foundation/CPString.j>
@import <Foundation/CPInvocation.j>

@implementation BlankSlate
{
}

+ alloc
{
  var instance = class_createInstance(self);

  instance.prototype = new objj_blankSlate();
  return instance;
}

+ initialize
{
}

+ load
{
}

- (id)methodSignatureForSelector: (SEL)aSelector
{
  return null;
}

- (id)forward: (SEL)aSelector :(id) args
{
  var signature = [self methodSignatureForSelector: aSelector];

  if (signature)
  {
    var invocation = [CPInvocation invocationWithMethodSignature: signature];
    [invocation setTarget: self]
    [invocation setSelector: aSelector]

    var index = 2,
        count = args.length;

    for (; index < count; ++index)
      [invocation setArgument: args[index] atIndex: index];

    [self forwardInvocation: invocation]
    return [invocation returnValue];
  }

  [self doesNotRecognizeSelector: aSelector]
}

- (CPString)description
{
  return "<" + isa.name + " 0x" + [CPString stringWithHash: __address] + ">";
}

- (void)forwardInvocation: (CPInvocation)anInvocation
{
  [self doesNotRecognizeSelector: [anInvocation selector]]
}

- (void)doesNotRecognizeSelector: (SEL)aSelector
{
  [CPException raise: CPInvalidArgumentException
               reason: (class_isMetaClass(isa) ? "+" : "-") + " [" +
                       isa.name + " " + aSelector + "] unrecognized selector " +
                       " sent to " +
                       (class_isMetaClass(isa) ? "class" : "instance") +
                       " 0x" + [CPString stringWithHash: __address]]
}

@end

function objj_blankSlate() {}
objj_blankSlate.prototype.toString = objj_object.prototype.toString;

