XV6-Modified
======

XV6-Modified is an OS cloned from [xv6 kernel](https://github.com/mit-pdos/xv6-public) with some new features . xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix
Version 6 (v6). 
- [POS](#pos)
	- [New Features](#new-features)
		- [Part 1 (Introduction to XV6):](#part-1-introduction-to-xv6)
		- [Part 2 (System Calls) :](#part-2-system-calls)
		- [Part 3 (Synchronization And Concurrency):](#part-3-synchronization-and-concurrency)
		- [Part 4 (CPU Scheduling):](#part-4-cpu-scheduling)
	- [How to use?](#how-to-use)


New Features 
------

### Part 1 (Introduction to XV6): 
* Writing names
* Added Ctrl+V, Ctrl+B, Ctrl+C, and Ctrl+X shortcuts.
* Some user programs like `lcm` added.
### Part 2 (System Calls) :
* Added some system calls
### Part 3 (Synchronization And Concurrency)
### Part 4 (CPU Scheduling):
* adding a multi-level feed back scheduler including :
	* Added multiple queue scheduling
  * Added RR, Lottery, and BJF algorithms
  * Added aging
  
How to use? 
------

you can make this kernel using `make` command.
also you can run this kernel on qemu virtual machine using `make qemu` command.

