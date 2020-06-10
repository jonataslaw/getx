# Benchmarks

Start the project, compile in PROFILE MODE (the debug mode is inconsistent for checking benchmarks), open the Dart inspector, and check the amount of ram used.

To be fair, the test was done twice: after the state changes, and after Dart's garbage collection (by manually pressing the garbage collector on the dart inspect).

Start testing and see for yourself.

## No GC 
Mobx = 4.58 
Bloc = 4.56 
Redux = 4.56
Bloc-Lib = 4.55 
Provider = 4.55 
GetX = 4.53 
Get = 4.53

## GC 
Bloc-lib = 4.22 
Mobx = 4.18
Bloc = 4.16 
Redux = 4.16 
Provider = 4.15 
GetX = 4.13 
Get = 4.14
