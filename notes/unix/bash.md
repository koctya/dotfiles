## Learning /bin and /usr/bin

When you have some spare time, something instructive to do that can help fill gaps in your Unix knowledge and to get a better idea of the programs installed on your system and what they can do is a simple whatis call, run over all the executable files in your /bin and /usr/bin directories. This will give you a one-line summary of the file’s function if available from man pages.

     tom@conan:/bin$ whatis *
     bash (1) - GNU Bourne-Again SHell
     bunzip2 (1) - a block-sorting file compressor, v1.0.4
     busybox (1) - The Swiss Army Knife of Embedded Linux
     bzcat (1) - decompresses files to stdout
     ...

     tom@conan:/usr/bin$ whatis *
     [ (1)                - check file types and compare values
     2to3 (1)             - Python2 to Python3 converter
     2to3-2.7 (1)         - Python2 to Python3 converter
     411toppm (1)         - convert Sony Mavica .411 image to ppm
     ...

It also works on many of the files in other directories, such as /etc:

   tom@conan:/etc$ whatis *
   acpi (1)             - Shows battery status and other ACPI information
   adduser.conf (5)     - configuration file for adduser(8) and addgroup(8)
   adjtime (3)          - correct the time to synchronize the system clock
   aliases (5)          - Postfix local alias database format
   ...
Because packages often install more than one binary and you’re only in the habit of using one or two of them, this process can tell you about programs on your system that you may have missed, particularly standard tools that solve common problems. As an example, I first learned about watch this way, having used a clunky solution with for loops with sleep calls to do the same thing many times before.