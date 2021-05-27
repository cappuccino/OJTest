@import <OJUnit/OJTestRunnerText.j>
@import <OJUnit/OJTestRunnerTextParallel.j>
@import <OJCov/OJCoverageRunnerText.j>
@import <OJSpec/OJSpec.j>

var LOCAL_OPTIONS_FILE = ".ojtest";

function help(status) {
  console.log("usage: " + require('path').basename(process.argv[1]) + " INPUT_FILE ...");
  console.log("Runs the given suite of tests.\nUsage: ojtest [OPTIONS] INPUT_FILE:NAME_OF_THE_TEST\nRuns only the given test of the given file");
  console.log("OPTIONS:");
  console.log("        -c            Runs test coverage along with your OJUnit tests.");
  console.log("        -t threshold  Set the threshold for test coverage to the specified percentage. Implies -c. Default: 0.8");
  console.log("        -l fatal | error | warn | info | debug | trace");
  console.log("                      Set the minimum log level. Default: warn");
  console.log("        -s            Run with OJSpec enabled (experimental). When this is stable, OJSpec will be enabled by default");
  console.log("        -h | --help   Print usage");
  process.exit(status);
}

function main(args) {
    var savedArgs = args.slice(0),
        options = {threshold: 0.8, level: "warn"},
        FILE = require("fs"),
        infiles = [];

    for (var i = 1; i < args.length; ++i) {
        var arg = args[i];
        if (arg == "-c") options.coverage = true;
        else if (arg == "-t") options.threshold = process.argv[++i];
        else if (arg == "-l") {
            if (![["fatal", "error", "warn", "info", "debug", "trace"] containsObject:options.level = process.argv[++i]]) {
              console.log("Minimum log level must be one of fatal, error, warn, info, debug or trace");
              help(1);
            }
        }
        else if (arg == "-s") options.spec = true;
        else if (arg == "--help") help(0);
        else if (arg == "-h") help(0);
        else infiles.push(arg);
    }

    if (!infiles.length) help(1);

    if (FILE.existsSync(LOCAL_OPTIONS_FILE))
    {
        var fileOptions = JSON.parse(FILE.readSync(LOCAL_OPTIONS_FILE, { encoding: 'utf8' }));
        for (var x in fileOptions)
            options[x] = fileOptions[x];
    }

    CPLogRegister(CPLogPrint, options.level);

    if (options.coverage || savedArgs.indexOf("-t") !== -1)
    {
        var threshold = options.threshold > 1 ? options.threshold / 100 : options.threshold,
            runner = [[OJCoverageRunnerText alloc] initWithThreshold:threshold];
    }
    else if (options.parallel)
    {
        require("narwhal").ensureEngine("rhino");
        var runner = [[OJTestRunnerTextParallel alloc] init];
    }
    else
    {
        var runner = [[OJTestRunnerText alloc] init];
    }

    [runner startWithArguments:infiles];
}
