@import <Foundation/CPObject.j>

SYSTEM = require("system");

@implementation OJCoverageReporter : CPObject
{
    CPDictionary            foundMethods;
    CPDictionary            calledMethods;
    CPArray                 ignoreClasses;
    
    float                   threshold       @accessors;
}

- (id)initWithThreshold:(float)aThreshold
{
    self = [super init];
    if(self)
    {
        [self reset];
        threshold = aThreshold;
        
        ignoreClasses = ["CPMutableDictionary", "CPString", "CPArray", "CPObject", "CPInvocation", 
            "CPDate", "CPNumber", "CPException"];
    }
    return self;
}

- (CPArray)objectsToIgnore
{
    return [self, calledMethods, foundMethods, threshold];
}

- (void)reset
{
    foundMethods = [CPDictionary dictionary];
    calledMethods = [CPDictionary dictionary];
}

- (void)foundMethod:(SEL)aMethod
{
    if([ignoreClasses containsObject:[[aMethod klass] description]] 
        || [[[aMethod klass] description] hasSuffix:@"Test"]
        || [[[aMethod klass] description] hasPrefix:@"CP"]
        || [[[aMethod klass] description] hasPrefix:@"_"]
        || [[[aMethod klass] description] hasPrefix:@"$"]
        || [[[aMethod klass] description] hasPrefix:@"OJ"]) return;

    [foundMethods setObject:[foundMethods objectForKey:aMethod]+1 forKey:aMethod];
}

- (void)calledMethod:(SEL)aMethod
{
    if([ignoreClasses containsObject:[[aMethod klass] description]] 
        || [[[aMethod klass] description] hasSuffix:@"Test"]
        || [[[aMethod klass] description] hasPrefix:@"CP"]
        || [[[aMethod klass] description] hasPrefix:@"_"]
        || [[[aMethod klass] description] hasPrefix:@"$"]
        || [[[aMethod klass] description] hasPrefix:@"OJ"]) return;
    
    [calledMethods setObject:[calledMethods objectForKey:aMethod]+1 forKey:aMethod];
}

- (void)report
{
    print("Calculating report...");
    
    if([calledMethods count] > 0)
        print("Methods Called: " + [calledMethods allValues].reduce(function(x, y) { return x + y; }));

    print("Methods Found : " + [foundMethods count]);

    [self generateHTML];
}

- (void)generateHTML
{
    FILE = require("file");
    var totalNumCalled = 0;
    var totalNumFound = 0;
    
    if(FILE.exists(FILE.absolute("results")))
        FILE.rmtree(FILE.absolute("results"));
    
    FILE.mkdir(FILE.absolute("results"));
    
    if(FILE.exists(FILE.absolute("results/index.html")))
        FILE.rm(FILE.absolute("results/index.html"));
    
    var index = "";

    var groupCalledMethods = [self groupMethodsByClassIn:calledMethods];
    var groupFoundMethods = [self groupMethodsByClassIn:foundMethods];
    
    for(var i = 0; i < [[groupCalledMethods allKeys] count]; i++) {
        var key = [[groupCalledMethods allKeys] objectAtIndex:i];
        var numCalled = [[groupCalledMethods objectForKey:key] count];
        var numFound = [[groupFoundMethods objectForKey:key] count];
        
        for(var k = 0; k < [[groupCalledMethods objectForKey:key] count]; k++) {
            var method = [[groupCalledMethods objectForKey:key] objectAtIndex:k];
            
            if(![[groupFoundMethods objectForKey:key] containsObject:method]) {
                numCalled--;
            }
        }

        if(numFound > 0) {
            index += li(a(key + " - " + numCalled + "/" + numFound + " : " + (numCalled/numFound * 100).toPrecision(4) + "\%", key+".html"));
        
            var link = "";
        
            for(var j = 0; j < [[groupFoundMethods objectForKey:key] count]; j++) {
                var array = [[groupFoundMethods objectForKey:key] objectAtIndex:j];
                link += div(array, ([[groupCalledMethods objectForKey:key] containsObject:array] ? "#66FF66" : "#FF6666"));
            }
        
            FILE.write(FILE.absolute("results/" + key + ".html"), html(head(title(key) + stylesheet()) 
                + body(divid(div(a("Home", "index.html")) + link, "result-container"))));
        }
        
        totalNumCalled += numCalled;
        totalNumFound += numFound;
    }

    FILE.write(FILE.absolute("results/index.html"), html(head(title("OJCov Results") + stylesheet()) + body(
            h1("The results are in!") + 
            h2("Run at " + [CPDate date]) +
            ul(index)
            )));

    var cssFile = FILE.join(SYSTEM.prefix, "packages", "OJTest", "Frameworks", "OJCov", "Resources", "style.css");
    FILE.copy(cssFile, FILE.absolute("results/style.css"));

    print([CPString stringWithFormat:"Your current test coverage is %@\%", (totalNumCalled / totalNumFound * 100).toPrecision(4)]);
    if(totalNumCalled / totalNumFound < threshold) {
        print("Exiting... Coverage not sufficient");
        require("os").exit(1);
    }
}

- (CPDictionary)groupMethodsByClassIn:(CPDictionary)methodList
{
    var result = [CPDictionary dictionary];
    
    for(var i = 0; i < [methodList count]; i++) {
        var key = [[[methodList allKeys] objectAtIndex:i] klass];
        if([[result allKeys] containsObject:key]) {
            if(![[result objectForKey:key] containsObject:[[methodList allKeys] objectAtIndex:i]])
                [[result objectForKey:key] addObject:[[methodList allKeys] objectAtIndex:i]];
        } else {
            [result setObject:[[[methodList allKeys] objectAtIndex:i]] forKey:key];
        }
    }
    
    return result;
}

- (BOOL)meetsThreshold
{
    return [foundMethods count] / [calledMethods count] > threshold;
}

- (CPArray)methodsNotCalled
{
    var result = [CPArray arrayWithArray:[foundMethods allKeys]];
    
    for(var i = 0; i < [calledMethods count]; i++)
    {
        var key = [calledMethods allKeys][i];
        if([result containsObject:key])
        {
            [result removeObject:key];
        }
    }
    
    return result;
}

@end

function h1(inner) {
    return tag("h1", inner);
}

function h2(inner) {
    return tag("h2", inner);
}

function a(inner, location) {
    return tag("a", inner, " href=\""+location+"\"");
}

function li(inner) {
    return tag("li", inner);
}

function ul(inner) {
    return tag("ul", inner);
}

function div(inner, color) {
    return tag("div", inner, " style=\"background-color:"+color+"\"");
}

function divid(inner, id) {
    return tag("div", inner, " id=\""+id+"\"");
}

function body(inner) {
    return tag("body", inner);
}

function stylesheet() {
    return "<link rel=\"stylesheet\" type=\"text/css\" href=\"style.css\" media=\"all\" />";
}

function title(inner) {
    return tag("title", inner)
}

function head(innerHEAD) {
    return tag("head", innerHEAD);
}

function html(innerHTML) {
    return tag("html", innerHTML);
}

function tag(name, inner, attributes) {
    return "<" + name + (attributes ? attributes : "") + ">" + inner + "</" + name + ">";
}
