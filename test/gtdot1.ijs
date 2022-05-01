1:@:(dbr bind Debug)@:(9!:19)2^_44[(prolog [ echo^:ECHOFILENAME) './gtdot1.ijs'
NB. T. t. ------------------------------------------------------------------

NB. **************************************** threads & tasks **********************************
NB. j904 64-bit only

TASK=: <: 9!:56'maxtasks'
TASK1=: 4 ] 12     NB. 12 crash   limit error of 1!:20

1: 0&T."1^:(0 < #) ''$~ (0 >. TASK-1 T. ''),0

STRIDE=: 3000                 NB. stride between tasks
NX=: 20

2!:0 :: 1:^:IFUNIX 'rm -rf ',jpath '~temp/tdot'
1!:55 ::1:^:IFWIN ((jpath'~temp/tdot/')&,)&.> {."1[ 1!:0 jpath '~temp/tdot/*' 
mkdir_j_ jpath '~temp/tdot'

NB. test parallel erase/write
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat written with around 1MB and then erased
t1=: 4 : 0"_ 0
NB. write file
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
for_xno. i.x do.
 f=. 'dat',~ jpath '~temp/tdot/f',":y+xno        NB. unique file name for each task
 l=. 1e6+?1e5                  NB. file length at leat 1e6
 (<f) 1!:2~ a=. a.{~?l#256     NB. write random data
 1!:55 <f                      NB. erase file
end.
1
)

NB. test erase/write on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
]&.> NX (t1 t.'')"0 [ i.TASK        NB. start task
)

NB. run & open the futures results
; s1''

NB. test parallel write/read
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat written with around 1MB and then read
t1=: 4 : 0"_ 0
NB. write file
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
z=. 1                          NB. initialize result
for_xno. i.x do.
 f=. 'dat',~ jpath '~temp/tdot/f',":y+xno        NB. unique file name for each task
 l=. 1e6+?1e5                  NB. file length at leat 1e6
 (<f) 1!:2~ a=. a.{~?l#256     NB. write random data
 z=. z *. a -: 1!:1 <f         NB. assert each read is successful
end.
z
)

NB. test write/read on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
]&.> NX (t1 t.'')"0 [ i.TASK        NB. start task
)

NB. run & open the futures results
; s1''


NB. test parallel read directroy
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
t1=: 4 : 0"_ 0
NB. read directory
for_xno. i.x do.
 1: 1!:0 '*'                   NB. read directory
end.
)

NB. test read directory on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
10 (t1 t.'')"0 [ i.TASK          NB. start task
)

NB. run & open the futures results
; s1''

NB. test parallel read/write/list
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat written with around 1MB and then read
NB. some threads list directory
t1=: 4 : 0"_ 0
assert. x<STRIDE NB. check for overlapping file names between tasks
z=. 1                          NB. initialize result
if. 0=2|y do.                  NB. write file even y
 y=. STRIDE * y                NB. offset of file name
NB. write file
 for_xno. i.x do.
  f=. 'dat',~ jpath '~temp/tdot/f',":y+xno       NB. unique file name for each task
  l=. 1e6+?1e5                 NB. file length at leat 1e6
  (<f) 1!:2~ a=. a.{~?l#256    NB. write random data
  z=. z *. a -: 1!:1 <f        NB. assert each read is successful
 end.
else.
NB. list directory for odd y
 z=. z *. 1: 1!:0 '*'          NB. ignore actual result
end.
z
)

NB. test read/write/list on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
]&.> NX (t1 t.'')"0 [ i.TASK        NB. start task
)

NB. run & open the futures results
; s1''

NB. test parallel append
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat appended around 100KB 100 times
t1=: 4 : 0"_ 0
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
NB. append file
for_xno. i.x do.
 f=. 'dat',~ jpath '~temp/tdot/f',":y+xno        NB. unique file name for each task
 l=. 1e6+?1e5                  NB. file length at leat 1e6
 1!:55 ::1: <f                 NB. erase file
 for_i. 100 do.                NB. append 100 times
  (<f) 1!:3~ (1e5+?1e5)#'a'    NB. append 1e5 character each time
 end.
end.
1
)

NB. test append on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
]&.> NX (t1 t.'')"0 [ i.TASK        NB. start task
)

NB. run & open the futures results
; s1''

NB. test parallel file size
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
t1=: 4 : 0"_ 0
NB. append file
for_xno. i.x do.
 s=. 1!:0 'f*dat'              NB. all files in directory
 1: 1!:4 {."1 s                NB. file size of all files, ignore result
end.
1
)

NB. test file size on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
10 (t1 t.'')"0 [ i.TASK          NB. start task
)

NB. run & open the futures results
; s1''

NB. test parallel create directory
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each directory with name f([0..x-1]+STRIDE*y)dir created
t1=: 4 : 0"_ 0
NB. create directory
assert. x<STRIDE NB. check for overlapping file names between tasks
if. 0=2|y do.                  NB. create directory even y
 y=. STRIDE * y                NB. offset of file name
 for_xno. i.x do.
  f=. 'dir',~ jpath '~temp/tdot/f',":y+xno       NB. unique directory name for each task
  1: 1!:5 <f                   NB. erase directory
 end.
else.
NB. list directory for odd y
 1: 1!:0 '*'                   NB. ignore actual result
end.
)

NB. test create directory on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
1!:55 :: 1: "0 -.&' '&.> <"1 'dir',~"1 '~temp/tdot/f',"1 ": ,. i.TASK*STRIDE   NB. clear all directories
10 (t1 t.'')"0 [ i.TASK          NB. start task
)

NB. run & open the futures results
; s1''

NB. test parallel indexed write/read
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat written with around 1MB and then read
t1=: 4 : 0"_ 0
NB. write file
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
z=. 1                          NB. initialize result
for_xno. i.x do.
 f=. 'dat',~ jpath '~temp/tdot/f',":y+xno        NB. unique file name for each task
 l=. ?1e5                      NB. file length at leat 1e6
 p=. ?1e6                      NB. random index position
 (f;p) 1!:12~ a=. l#'a'        NB. write l#'a' at position p
 z=. z *. a -: 1!:11 f;p,l     NB. assert each read is successful
end.
z
)

NB. test indexed write/read on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
1!:55 :: 1: "0 -.&' '&.> <"1 'dat',~"1 '~temp/tdot/f',"1 ": ,. i.TASK*STRIDE   NB. clear all files
]&.> NX (t1 t.'')"0 [ i.TASK  NB. start task, too many files limit error if x it too large
)

NB. run & open the futures results
; s1''

NB. test parallel file open/close
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat written with around 1MB and then read
t1=: 4 : 0"_ 0
NB. write file
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
z=. 1                          NB. initialize result
fs=. ''                        NB. file name list
fns=. 0$0                      NB. file number list
for_xno. i.x do.
 fs=. fs, <f=. 'dat',~ jpath '~temp/tdot/f',":y+xno    NB. unique file name for each task
 l=. 1e6+?1e5                  NB. file length at leat 1e6
 1!:55 ::1:<f                  NB. erase file if exist
 fns=. fns, fn=. 1!:21 <f      NB. open file
 (fn) 1!:2~ a=. a.{~?l#256     NB. write random data
 z=. z *. a -: 1!:1 fn         NB. assert each read is successful
end.
z=. z *. *./ ((<"0 fns),.fs) e. 1!:20''    NB. file name and list should agree with 1!:20
z=. z *. *./ 1!:22 fns                     NB. close all files
z=. z *. *./ 0= ((<"0 fns),.fs) e. 1!:20'' NB. file name and list should not be inside 1!:20
z
)

NB. test file open/close on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
]&.> NX (t1 t.'')"0 [ i.TASK1  NB. start task, too many files limit error if x it too large
)

NB. run & open the futures results
; s1''


NB. test parallel file indexed read/write
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat written with around 1MB and then read
t1=: 4 : 0"_ 0
NB. write file
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
z=. 1                          NB. initialize result
fs=. ''                        NB. file name list
fns=. 0$0                      NB. file number list
for_xno. i.x do.
 fs=. fs, <f=. 'dat',~ jpath '~temp/tdot/f',":y+xno    NB. unique file name for each task
 l=. ?1e5                      NB. file length at leat 1e6
 p=. ?1e6                      NB. random index position
 1!:55 ::1:<f                  NB. erase file if exist
 fns=. fns, fn=. 1!:21 <f      NB. open file
 (fn,p) 1!:12~ a=. a.{~?l#256  NB. write random data
 z=. z *. a -: 1!:11 fn,p,l    NB. assert each read is successful
end.
z=. z *. *./ ((<"0 fns),.fs) e. 1!:20''    NB. file name and list should agree with 1!:20
z=. z *. *./ 1!:22 fns                     NB. close all files
z=. z *. *./ 0= ((<"0 fns),.fs) e. 1!:20'' NB. file name and list should not be inside 1!:20
z
)

NB. test file indexed read/write on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
]&.> NX (t1 t.'')"0 [ i.TASK1  NB. start task, too many files limit error if x it too large
)

NB. run & open the futures results
; s1''

NB. test parallel getcwd/chdir directory
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each directory with name f([0..x-1]+STRIDE*y)dir created
NB. !!! current directory is per process
t1=: 4 : 0"_ 0
NB. getcwd/chdir
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
a=. 1!:43''                    NB. original directory
for_xno. i.x do.
 f=. 'dir',~ jpath '~temp/tdot/f',":y+xno        NB. unique directory name for each task
 1!:5 <f                       NB. create directory
 6!:3]0.001
 1!:44 f                       NB. chdir new directory
 6!:3]0.001
 1!:43''                       NB. getcwd, result may NOT be f
 6!:3]0.001
 1!:44 a                       NB. restore to original directory
 6!:3]0.001
 1!:55 <f                      NB. erase directory
end.
1
)

NB. test getcwd/chdir on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
1!:55 :: 1: "0 -.&' '&.> <"1 'dir',~"1 '~temp/tdot/f',"1 ": ,. i.TASK*STRIDE   NB. clear all directories
10 (t1 t.'')"0 [ i.TASK          NB. start task
)

NB. test parallel file lock
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat written with around 1MB and then read
t1=: 4 : 0"_ 0
NB. write file
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
z=. 1                          NB. initialize result
fs=. ''                        NB. file name list
fns=. 0$0                      NB. file number list
for_xno. i.x do.
 fs=. fs, <f=. 'dat',~ jpath '~temp/tdot/f',":y+xno       NB. unique file name for each task
 l=. ?1e5                      NB. file length at leat 1e6
 p=. ?1e6                      NB. random index position
 1!:55 ::1:<f                  NB. erase file if exist
 fns=. fns, fn=. 1!:21 <f      NB. open file
 (fn,p) 1!:12~ a=. a.{~?l#256  NB. write random data
 z=. z *. a -: 1!:11 fn,p,l    NB. assert each read is successful
 1!:31 fn, p, l                NB. lock file fn at position p for length l
 assert. (fn,p,l) e. 1!:30 ''  NB. check file entry in lock table
 1!:32 fn, p, l                NB. unlock file
 assert. (fn,p,l) -.@e. 1!:30 ''   NB. file entry shouldn't exist in lock table
end.
z=. z *. *./ ((<"0 fns),.fs) e. 1!:20''    NB. file name and list should agree with 1!:20
z=. z *. *./ 1!:22 fns                     NB. close all files
z=. z *. *./ 0= ((<"0 fns),.fs) e. 1!:20'' NB. file name and list should not be inside 1!:20
z
)

NB. test file lock on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
NB. file lock only available for windows
if. IFWIN do.
 ]&.> NX (t1 t.'')"0 [ i.TASK1    NB. start task, too many files limit error if x it too large
else.
 1
end.
)

NB. run & open the futures results
; s1''

NB. test parallel file attribute/permission
NB. x is number of iteration in each task
NB. y is a task number
NB. result is always 1
NB. each file with name f([0..x-1]+STRIDE*y)dat written with around 1MB and then read
t1=: 4 : 0"_ 0
NB. write file and check attribute/permission
assert. x<STRIDE NB. check for overlapping file names between tasks
y=. STRIDE * y                 NB. offset of file name
for_xno. i.x do.
 f=. 'dat',~ jpath '~temp/tdot/f',":y+xno        NB. unique file name for each task
 l=. ?1e5                      NB. file length at leat 1e6
 (<f) 1!:2~ a=. a.{~?l#256     NB. write random data
 b=. 1!:6 <f                   NB. query file attribute
 b 1!:6 <f                     NB. set file attribute
 b=. 1!:7 <f                   NB. query file permission
 b 1!:7 <f                     NB. set file permission
 1!:55 <f                      NB. erase file
end.
)

NB. test file attribute/permission on multiple threads
NB. Nilad.  Result is list of results from each thread
s1=: 3 : 0
NB. 1!:6/7 only available for windows
if. IFWIN do.
 ]&.> NX (t1 t.'')"0 [ i.TASK       NB. start task
else.
 1
end.
)

NB. run & open the futures results
; s1''

2!:0 :: 1:^:IFUNIX 'rm -rf ',jpath '~temp/tdot'
1!:55 ::1:^:IFWIN ((jpath'~temp/tdot/')&,)&.> {."1[ 1!:0 jpath '~temp/tdot/*' 

4!:55 ;:'NX STRIDE TASK1 TASK s1 t1 '
