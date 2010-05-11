
@import <Foundation/Foundation.j>

@import "CPObject+Specs.j"
@import "Test.j"
@import "Formatting.j"

args.forEach(function(file) {
    [Test resetSpecs];
    
    var results =
        [Test runSpecsOn:file
                whenDone:function(results) {
                            /*
                                @todo
                                Some really ugly var names but it works. Should rename these whenever I
                                think of any name that fits better.
                             */
                            var totalExamples = 0,
                                totalPending = 0,
                                totalFailures = 0,
                                totalExceptions;
                            
                            for (var category in results)
                            {
                                var categoryExamples = 0,
                                    categoryPending = 0,
                                    categoryFailures = 0,
                                    categoryExceptions = 0;
                                
                                var catResults = results[category];
                                print("\n" + category);
                                
                                catResults.forEach(function(result) {
                                    totalExamples++;
                                    categoryExamples++;
                                    
                                    if (result.status == "success")
                                    {
                                        print(green(" - should " + result.spec));
                                    }
                                    else if (result.status == "pending")
                                    {
                                        print(yellow(" - should " + result.spec + " - PENDING"));
                                        
                                        totalPending++;
                                        categoryPending++;
                                    }
                                    else if (result.status == "failure")
                                    {
                                        print(red(" - should " + result.spec + " - FAILURE"));
                                        
                                        totalFailures++;
                                        categoryFailures++;
                                    }
                                    else if (result.status == "exception")
                                    {
                                        print(blue(" - should " + result.spec + " - EXCEPTION"));
                                        
                                        var exc = result.exception;
                                        
                                        if (exc.isa)
                                        {
                                            print(blue("     " + exc.name + ": " + exc.reason));
                                        }
                                        else
                                        {
                                            print(blue("     " + exc.name + ": " + exc.message));
                                            print(exc.stack);
                                        }
                                        
                                        totalExceptions++;
                                        categoryExceptions++;
                                    }
                                });
                                
                                var output = "";
                                
                                output += categoryExamples + " example" + (categoryExamples > 1 ? "s, " : ", ");
                                output += (categoryFailures + categoryExceptions) + " failure" + (categoryFailures + categoryExceptions > 1 ? "s" : '');
                                
                                if(categoryPending > 0)
                                {
                                    output += ", " + categoryPending + " pending";
                                }
                                
                                if (categoryExceptions == 1)
                                    output += ", " + categoryExceptions + " due to an exception.";
                                else if (categoryExceptions > 0)
                                    output += ", " + categoryExceptions + " due to exceptions.";
                                else
                                    output += ".";
                                
                                if (categoryFailures + categoryExceptions > 0)
                                    output = red(output);
                                else
                                    output = green(output);
                                
                                print("\n" + output);
                            }
        }];
});
