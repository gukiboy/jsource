NB. Unicode 4-byte characters -------------------------------------------

UTYPE=: 512      NB. type code for Unicode

domerr=: 1 : 0
 if. 1 e. y do. 
  assert. 'domain error' -: u etx 10 u: 'abcd'
 end.
 if. 2 e. y do.
  assert. 'domain error' -: 2          u etx 10 u: 'abc'
  assert. 'domain error' -: (10 u: 'xyz') u etx 2
  assert. 'domain error' -: (10 u: 'xyz') u etx 10 u: 'abc'
 end.
 if. 'l' e. y do.
  assert. 'domain error' -: (10 u: 'ab')  u etx i.2 3
 end.
 if. 'r' e. y do.
  assert. 'domain error' -: 2 3 4      u etx 10 u: 'abc'
 end.
 1
)


NB. u: ------------------------------------------------------------------

x=: 10 u: i=: _65536 + 16b10000 +2 3 4 ?@$ 2*65536
($x) -: $i
UTYPE -: type x
(i) -: 3 u: x

x=: 10 u: t=: a.{~ i=: ?2 3 4$#a.
($x) -: $i
UTYPE -: type x
x -: t
t -: 1 u: x
i -: 3 u: x

x=: 10 u: y=: 10 u: i=: _65536 + 16b10000 +2 3 4 ?@$ 2*65536
($x) -: $i
UTYPE -: type x
(i) -: 3 u: x
x -: y
(3!:1 x) -: 3!:1 y

2 -: type 9 u: 128{.a.
'domain error' -: 9 u: etx 128}.a.
UTYPE -: type 10 u: 128{.a.
UTYPE -: type 10 u: 128}.a.

i -: 3 u: 10 u: i=: i.16b110000
($i) = $ 10 u: i
(10 u: i) -: 9 u: i
($i) = $ 9 u: i
($i) < $ 7 u: i
($i) < $ 8 u: i

i -: 3 u: 10 u: i=: i -. (16bd800+i.16b800)  NB. less surrogate
(10 u: i) -: 9 u: 7 u: i
(10 u: i) -: 9 u: 8 u: i

NB. x=: a.{~?3 5 7 2$#a.
NB. y=: 6 u: x
NB. ($y) -: (}:$x),-:{:$x
NB. 
NB. lr=: 1 : '5!:5 <''u'''
NB. 2&u: lr -: 1&u: b. _1
NB. 1&u: lr -: 2&u: b. _1
NB. 4&u: lr -: 3&u: b. _1
NB. 3&u: lr -: 4&u: b. _1

'domain error' -: 10 u: etx 0 1.2
'domain error' -: 10 u: etx 0 1j2
'domain error' -: 10 u: etx 0 1r2
'domain error' -: 10 u: etx 0 1;2

NB. 'domain error' -:  0 u: etx 0 1 2
NB. 'domain error' -: _1 u: etx 0 1 2
NB. 'domain error' -: _2 u: etx 0 1 2
NB. 'domain error' -: _3 u: etx 0 1 2
NB. 'domain error' -: _4 u: etx 0 1 2
NB. 
NB. 'domain error' -:  0 u: etx 'abc'
NB. 'domain error' -: _1 u: etx 'abc'
NB. 'domain error' -: _2 u: etx 'abc'
NB. 'domain error' -: _3 u: etx 'abc'
NB. 'domain error' -: _4 u: etx 'abc'
NB. 
NB. 'index error'  -:  4 u: etx 1 2 3 65536
NB. 
NB. 'length error' -:  6 u: etx 'abc'
NB. 'length error' -:  6 u: etx 'abcde'

NB. 7&u:  8&u:

NB.  bmp pane
0 -: 3 u: 10 u: u: 0
(,16b7f) -: 3 u: 8 u: 9 u: 16b7f
194 128 -: 3 u: 8 u: 9 u: 16b80
223 191 -: 3 u: 8 u: 9 u: 16b7ff
224 160 128 -: 3 u: 8 u: 9 u: 16b800
239 191 191 -: 3 u: 8 u: 9 u: 16bffff
16b1234 16b5678 -: 3&u: 9 u: 16b1234 16b5678
225 136 180 229 153 184 -: 3&u: 8&u: 9 u: 16b1234 16b5678

NB. null
0 128 0 129 0 0 65535 0 -: 3&u: 9 u: 0 128 0 129 0 0 65535 0
0 194 128 0 194 129 0 0 239 191 191 0 -: 3 u: 8 u: 9 u: 0 128 0 129 0 0 65535 0
(7 u: a.{~0 194 128 0 194 129 0 0 239 191 191 0) -: 9 u: 0 128 0 129 0 0 65535 0

NB. invalid range
'index error' -: 9 u: etx _1
'index error' -: 9 u: etx 16b110000

NB. invalid utf-16 surrogate
237 159 191 -: 3 u: 8 u: u: 16bd7ff
238 128 128 -: 3 u: 8 u: u: 16be000
'domain error' -: 9 u: etx u: 16bd800
'domain error' -: 9 u: etx u: 16bdfff

'domain error' -: 9 u: etx u: 16bd800 16bd7ff
'domain error' -: 9 u: etx u: 16bd800 16be000
'domain error' -: 9 u: etx u: 16bdbff 16bd7ff
'domain error' -: 9 u: etx u: 16bdbff 16be000

'domain error' -: 9 u: etx u: 16bd800 16bd800
'domain error' -: 9 u: etx u: 16bd800 16bdbff
'domain error' -: 9 u: etx u: 16bdbff 16bd800
'domain error' -: 9 u: etx u: 16bdbff 16bdbff

'domain error' -: 9 u: etx u: 16bdc00 16bd800
'domain error' -: 9 u: etx u: 16bdc00 16bdbff
'domain error' -: 9 u: etx u: 16bdfff 16bd800
'domain error' -: 9 u: etx u: 16bdfff 16bdbff

'domain error' -: 9 u: etx u: 16bd800 16bdfff 16bd800
'domain error' -: 9 u: etx u: 16bd800 16bdfff 16bdfff

NB. non-bmp pane
NB. U+10000
(,16b10000) -: 3 u: 9 u: u: 16bd800 16bdc00
NB. U+10ffff
(,16b10ffff) -: 3 u: 9 u: u: 16bdbff 16bdfff
NB. U+110000 (utf-8 f4 90 80 80) invalid
'domain error' -: 9 u: etx a.{~244 144 128 128

NB. U+12345
55304 57157 -: 3&u: u: 16bd808 16bdf45
(,16b12345) -: 3&u: 9 u: u: 16bd808 16bdf45
(,10 u: 16b12345) -: 9 u: u: 16bd808 16bdf45

NB. errors in various primitives ----------------------------------------

<       domerr   2
<.      domerr 1 2
<:      domerr 1 2
>       domerr   2
>.      domerr 1 2
>:      domerr 1 2
+       domerr 1 2
+.      domerr 1 2
+:      domerr 1 2
*       domerr 1 2
*.      domerr 1 2
*:      domerr 1 2
-       domerr 1 2
-.      domerr 1
-:      domerr 1
%       domerr 1 2
%.      domerr 1 2
%:      domerr 1 2
^       domerr 1 2
^.      domerr 1 2
$       domerr 'l'
$.      domerr 1 2
|       domerr 1 2
|.      domerr 'l'
|:      domerr 'l'
+/ .*   domerr 1 2
<;.1    domerr 'l'
#.      domerr 1 2
#:      domerr 1 2
!       domerr 1 2
]\      domerr 'l'
]\.     domerr 'l'
{       domerr 'l'
{.      domerr 'l'
}.      domerr 'l'
?       domerr 1 2
?.      domerr 1 2
? @$    domerr   2
? @#    domerr   2
?.@$    domerr   2
?.@#    domerr   2
i.      domerr 1
i:      domerr 1
j.      domerr 1 2
o.      domerr 1 2
p.      domerr 1 2
p:      domerr 1
q:      domerr 1 2
r.      domerr 1 2
x:      domerr 1 2


NB. = -------------------------------------------------------------------

x=: 10 u: i=: t{~?2 3 41$#t=: ?19$16b110000
y=: 10 u: j=: t{~?2 3 41$#t
z=: 10 u: k=: t{~?2 3   $#t

(=x) -: =i
(=y) -: =j
(=z) -: =k

(x =   y  ) -: i =   j
(x =   z  ) -: i =   k
(x =/  z  ) -: i =/  k
(x ="2 {.y) -: i ="2 {.j

x=: 10 u: y=: a.{~?2 3 4$#a.
UTYPE -: type x
2     -: type y
*./@, x = y


NB. < -------------------------------------------------------------------

x=: 10 u: a.{~?257##a.
x -: ><   x
x -: ><"0 x


NB. > -------------------------------------------------------------------

x=: 10 u: i=: t{~?2 3 41$#t=: ?19$16b110000
y=: 10 u: j=: t{~?2 3 41$#t
z=: a.{~ ? 2 3$#a.

(>x;y) -: 10 u: >i;j
(>x;z) -: x ,: ($x){.,:z

'domain error' -: > etx x;0 1 0
'domain error' -: > etx x;1 2 3
'domain error' -: > etx x;1 2.3
'domain error' -: > etx x;1 2j3
'domain error' -: > etx x;1 2 3x
'domain error' -: > etx x;1 2r3
'domain error' -: > etx x;<<2 3


NB. -. ------------------------------------------------------------------

x=: 10 u: i=: t{~?41$#t=: ?41 7 3$16b110000
y=: 10 u: j=: t{~?23$#t
(x -. y) -: 10 u: i -. j

x=: u: i=: t{~?41$#t=: a.{~ ?41 7 3$256
y=: u: j=: t{~?41$#t

(x -.   y) -: 10 u: i -.   j
(x -.   y) -: 10 u: i -.   y
(x -.   y) -: 10 u: x -.   j

(x -."1 y) -: 10 u: i -."1 j
(x -."1 y) -: 10 u: i -."1 y
(x -."1 y) -: 10 u: x -."1 j

(x -."2 y) -: 10 u: i -."2 j
(x -."2 y) -: 10 u: i -."2 y
(x -."2 y) -: 10 u: x -."2 j


NB. -: ------------------------------------------------------------------

x=: 10 u: y=: a.{~?317##a.
x -: ,x
x -: y


NB. $ --------------------------------------------------------------------

(31     $ 10 u: i) -: 10 u: 31     $ i=: ?7$16b110000
(31 4   $ 10 u: i) -: 10 u: 31 4   $ i=: ?7$16b110000
(31 4 5 $ 10 u: i) -: 10 u: 31 4 5 $ i=: ?7$16b110000


NB. ~ --------------------------------------------------------------------

f=: +/
45 -: (10&u: 'f')~ i.10


NB. ~. -------------------------------------------------------------------

(~. 10&u: i) -: 10&u: ~. i=: t{~?541    $#t=: ?97$16b110000
(~. 10&u: i) -: 10&u: ~. i=: t{~?541   3$#t=: ?13$16b110000
(~. 10&u: i) -: 10&u: ~. i=: t{~?541 2 3$#t=: ? 5$16b110000

(~.t) -: ~.t,10&u:   t=: a.{~?100  $#a.
(~.t) -: ~.t,10&u:   t=: a.{~?200 3$#a.

(~.t) -: ~.t,10&u:&.>t=: <"_1 a.{~   ?100  $#a.
(~.t) -: ~.t,10&u:&.>t=: <"_1 a.{~97+?200 3$3


NB. ~: ------------------------------------------------------------------

x=: 10 u: i=: t{~?2 3 41$#t=: ?19$16b110000
y=: 10 u: j=: t{~?2 3 41$#t
z=: 10 u: k=: t{~?2 3   $#t

(x ~:   y  ) -: i ~:   j
(x ~:   z  ) -: i ~:   k
(x ~:/  z  ) -: i ~:/  k
(x ~:"2 {.y) -: i ~:"2 {.j

x=: 10 u: y=: a.{~?2 3 4$#a.
UTYPE -: type x
2     -: type y
-. +./@, x ~: y


NB. |. -------------------------------------------------------------------

x=: 10 u: i=: t{~?41 2 3$#t=: ?119$16b110000
(|.   x) -: 10 u: |.   i
(|."1 x) -: 10 u: |."1 i
(|."2 x) -: 10 u: |."2 i

(j|.   x) -: 10 u: j|.   i [ j=: ?0{$x
(j|."1 x) -: 10 u: j|."1 i [ j=: ?1{$x
(j|."2 x) -: 10 u: j|."2 i [ j=: ?2{$x


NB. |: -------------------------------------------------------------------

x=: 10 u: i=: t{~?2 3 5 7 11$#t=: ?119$16b110000
(|:   x) -: 10 u: |:   i
(|:"1 x) -: 10 u: |:"1 i
(|:"2 x) -: 10 u: |:"2 i

(j|:x) -: 10 u: j|:i [ j=: ?~#$x
(j|:x) -: 10 u: j|:i [ j=: ?~#$x
(j|:x) -: 10 u: j|:i [ j=: ?~#$x

(j|:x) -: 10 u: j|:i [ j=: C. ?~#$x
(j|:x) -: 10 u: j|:i [ j=: C. ?~#$x
(j|:x) -: 10 u: j|:i [ j=: C. ?~#$x


NB. : -------------------------------------------------------------------

x -: 0 : x=: 'super duper stare decisis'

f=: 1 : (10&u: 'u/')
45 -: +f i.10

f=: 2 : (10&u: 'u&.:v')
5 -: +/ f *: 3 4

f=: 3 : (10&u: '(* f@<:)^:(1<y) 1>.y')
1 1 120 720 -: f"0 ]0 1 5 6

f=: 3 : (10&u:&.> 't=.y+1';'t*t')
25 -: f 4

f=: 4 : (10&u: 'x+y')
45 -: f/ i.10

f=: 13 : (10&u: 'x*y')
120 -: f/1+i.5


NB. ;. ------------------------------------------------------------------

x=: ' boustrophedonic triskaidekaphobia deipnosophist chthonic'
(<   ;.1 (10&u:) x) -: 10&u:&.>    <;.1 x
([   ;.1 (10&u:) x) -: 10&u:       [;.1 x
(,   ;.1 (10&u:) x) -: 10&u:       ,;.1 x
(#   ;.1 (10&u:) x) -:          #;.1 x
(<@}.;.1 (10&u:) x) -: 10&u:&.> <@}.;.1 x
(<@}:;.1 (10&u:) x) -: 10&u:&.> <@}:;.1 x


NB. ;: ------------------------------------------------------------------

(;: -: ;:@(10&u:)) '3+4'
(;: -: ;:@(10&u:)) '+'

0 $ 0 : 0
sq=: 4 2 2$ 1 1 2 1  1 0 2 2  2 0 3 0  1 2 2 0
x=: 0;sq;''''=a.
(x&;: -: x&;:@(10&u:)) '''The Power of the Powerlesss'' by Havel'
)

'domain error' -: ;: etx (10 u: 257),'3+4'


NB. 0!: -----------------------------------------------------------------

0!:0 (10&u:) 'x=: i.2 3 4'
x -: i.2 3 4


NB. 1!: -----------------------------------------------------------------

(1!:0 '*.*') -: 1!:0 (9&u:) '*.*'
x=: ' triskaidekaphobia deipnosophist boustrophedonic octothorpe'
(8 u: 10 u: x) 1!:2 <8 u: 10 u: 'asdf'
x -: 1!:1 <8 u: 10 u: 'asdf'

x=: 10&u: ?237$16b110000
x 1!:2 <'asdf'
(3 u: x) -: _2&ic 1!:1 <'asdf'
(3 u: x) -: _2&ic 1!:1 <8 u: u: 'asdf'

x=: 'everything not forbidden is mandatory'
x 1!:2 <8 u: 10 u: 'asdf'
x -: 1!:1 <8 u: 10 u: 'asdf'
'01234' 1!:3 <8 u: 'asdf'
(x,'01234') -: 1!:1 <8 u: 10 u: 'asdf'
(5+#x) -: 1!:4 <8 u: 10 u: 'asdf'

3 : 0 ''
 if. (9!:12 '') e. 6 do.  NB. do only if PC
  assert. (1!:6@< -: 1!:6@<@(8&u:)@(10&u:)) 'asdf'
  assert. (1!:6 <'asdf') 1!:6 <8 u: 10 u: 'asdf'
  assert. (1!:7@< -: 1!:7@<@(8&u:)@(10&u:)) 'asdf'
  assert. (1!:7 <'asdf') -: 1!:7 <8 u: 10 u: 'asdf'
 end.
 1
)

'01234' -: 1!:11 (8 u: 10 u: 'asdf');(#x),5
'abcde' 1!:12 (8 u: 10 u: 'asdf');#x
'abcde' -: 1!:11 (8 u: 10 u: 'asdf');(#x),5

t=: 1!:21 <8 u: 10 u: 'asdf'
+./@('asdf'&E.)&> {:"1 (1!:20) ''
1!:22 t

1!:55 <8 u: 10 u: 'asdf'


NB. 3!:n ----------------------------------------------------------------

UTYPE -: 3!:0 [ 10 u: 'abc'

f=: 3 : 0
 assert. y -: (3!:2) 00 (3!:1) y
 assert. y -: (3!:2) 01 (3!:1) y
 assert. y -: (3!:2) 10 (3!:1) y
 assert. y -: (3!:2) 11 (3!:1) y
 assert. y -: (3!:2) 00 (3!:3) y
 assert. y -: (3!:2) 01 (3!:3) y
 assert. y -: (3!:2) 10 (3!:3) y
 assert. y -: (3!:2) 11 (3!:3) y
 1
)

f x=: 10 u: 0
f x=: 10 u: 65535
f x=: 10 u: ?257      $16b110000
f x=: 10 u: ?257 2    $16b110000
f x=: 10 u: ?257 2 3  $16b110000
f x=: 10 u: ?257 2 3 5$16b110000
f x=: 10 u: ?257 2147483647 2e9 2e9 2e9 0$16b110000


1: (0 : 0)
NB. /: ------------------------------------------------------------------

(/:   i) -: /:   x=: 10 u: i=: ?  313 1$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?  313 2$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?  313 3$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?  313 4$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?  313 5$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?  313 6$16b110000

(/:"2 i) -: /:"2 x=: 10 u: i=: ?7 313 1$16b110000
(/:"2 i) -: /:"2 x=: 10 u: i=: ?7 313 2$16b110000
(/:"2 i) -: /:"2 x=: 10 u: i=: ?7 313 3$16b110000
(/:"2 i) -: /:"2 x=: 10 u: i=: ?7 313 4$16b110000
(/:"2 i) -: /:"2 x=: 10 u: i=: ?7 313 5$16b110000
(/:"2 i) -: /:"2 x=: 10 u: i=: ?7 313 6$16b110000

(/:   i) -: /:   x=: 10 u: i=: ?13 1231$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?13 1232$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?13 1233$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?13 1234$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?13 1235$16b110000
(/:   i) -: /:   x=: 10 u: i=: ?13 1236$16b110000

(/:"1 i) -: /:"1 x=: 10 u: i=: ?13 1231$16b110000
(/:"1 i) -: /:"1 x=: 10 u: i=: ?13 1232$16b110000
(/:"1 i) -: /:"1 x=: 10 u: i=: ?13 1233$16b110000
(/:"1 i) -: /:"1 x=: 10 u: i=: ?13 1234$16b110000
(/:"1 i) -: /:"1 x=: 10 u: i=: ?13 1235$16b110000
(/:"1 i) -: /:"1 x=: 10 u: i=: ?13 1236$16b110000


NB. \: ------------------------------------------------------------------

(\:   i) -: \:   x=: 10 u: i=: ?  313 1$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?  313 2$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?  313 3$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?  313 4$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?  313 5$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?  313 6$16b110000

(\:"2 i) -: \:"2 x=: 10 u: i=: ?7 313 1$16b110000
(\:"2 i) -: \:"2 x=: 10 u: i=: ?7 313 2$16b110000
(\:"2 i) -: \:"2 x=: 10 u: i=: ?7 313 3$16b110000
(\:"2 i) -: \:"2 x=: 10 u: i=: ?7 313 4$16b110000
(\:"2 i) -: \:"2 x=: 10 u: i=: ?7 313 5$16b110000
(\:"2 i) -: \:"2 x=: 10 u: i=: ?7 313 6$16b110000

(\:   i) -: \:   x=: 10 u: i=: ?13 1231$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?13 1232$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?13 1233$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?13 1234$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?13 1235$16b110000
(\:   i) -: \:   x=: 10 u: i=: ?13 1236$16b110000

(\:"1 i) -: \:"1 x=: 10 u: i=: ?13 1231$16b110000
(\:"1 i) -: \:"1 x=: 10 u: i=: ?13 1232$16b110000
(\:"1 i) -: \:"1 x=: 10 u: i=: ?13 1233$16b110000
(\:"1 i) -: \:"1 x=: 10 u: i=: ?13 1234$16b110000
(\:"1 i) -: \:"1 x=: 10 u: i=: ?13 1235$16b110000
(\:"1 i) -: \:"1 x=: 10 u: i=: ?13 1236$16b110000
)

NB. ". ------------------------------------------------------------------

3 4 5 -:    ". 10 u: '3 4 5'
3 4 5 -: _1 ". 10 u: '3 4 5'


NB. E. ------------------------------------------------------------------

x=:                           a.{~(a.i.'a')+?  31$26
y=: x ((?19$y-&#x)+/i.#x)}y=: a.{~(a.i.'a')+?3111$26
(x E. y) -: x E.&(10&u:) y

x=:                           ?  31$16b110000
y=: x ((?19$y-&#x)+/i.#x)}y=: ?9111$16b110000
(x E. y) -: x E.&(10&u:) y


NB. i. ------------------------------------------------------------------

x=: 10 u: i=: t{~?257$#t=: ?19$16b110000
y=: 10 u: j=: t{~?521$#t
(x i. y) -: i i. j
(y i. x) -: j i. i

x=: 10 u: i=: t{~?257$#t=: a.
y=: 10 u: j=: t{~?521$#t
(x i. y) -: i i. j
(y i. x) -: j i. i

x=: 10 u: i=: t{~?257 2 3$#t=: ?7$16b110000
y=: 10 u: j=: t{~?521 2 3$#t
(x i. y) -: i i. j
(y i. x) -: j i. i

x=: 10 u: i=: t{~?257 2 3$#t=: a.
y=: 10 u: j=: t{~?521 2 3$#t
(x i. y) -: i i. j
(y i. x) -: j i. i

x=: a.{~97+?10$26
y=: 10 u: x
(x i. 1{x) -: y i. 1{y
(x i. 'x') -: y i. 10 u: 'x'
(x i. '9') -: y i. 10 u: '9'

NB. simple repeatable test
(t i. t,t) -: t i. t, t0=. (10&u:)&.>t=: <"_1 'gfcceggefegcaeceebda'

(t i.&:> t,t) -: t        i. t, (10&u:)&.>t=: <"_1 a.{~   ?100  $#a.
(t i.&:> t,t) -: t        i. t,~(10&u:)&.>t
(t i.&:> t,t) -: ((10&u:)&.>t) i. t, (10&u:)&.>t
(t i.&:> t,t) -: ((10&u:)&.>t) i. t,~(10&u:)&.>t

(t i.&:> t,t) -: t        i. t, (10&u:)&.>t=: <"_1 a.{~97+?100 3$3
(t i.&:> t,t) -: t        i. t,~(10&u:)&.>t
(t i.&:> t,t) -: ((10&u:)&.>t) i. t, (10&u:)&.>t
(t i.&:> t,t) -: ((10&u:)&.>t) i. t,~(10&u:)&.>t

f=: 3 : 'a.{~ ?(y,6)$#a.  '
g=: 3 : '10 u:   ?(y,6)$16b110000'


NB. i: ------------------------------------------------------------------

x=: 10 u: i=: t{~?257$#t=: ?19$16b110000
y=: 10 u: j=: t{~?521$#t
(x i: y) -: i i: j
(y i: x) -: j i: i

x=: 10 u: i=: t{~?257$#t=: a.
y=: 10 u: j=: t{~?521$#t
(x i: y) -: i i: j
(y i: x) -: j i: i

x=: 10 u: i=: t{~?257 2 3$#t=: ?7$16b110000
y=: 10 u: j=: t{~?521 2 3$#t
(x i: y) -: i i: j
(y i: x) -: j i: i

x=: 10 u: i=: t{~?257 2 3$#t=: a.
y=: 10 u: j=: t{~?521 2 3$#t
(x i: y) -: i i: j
(y i: x) -: j i: i

x=: a.{~97+?10$26
y=: 10 u: x
(x i: 1{x) -: y i: 1{y
(x i: 'x') -: y i: 10 u: 'x'
(x i: '9') -: y i: 10 u: '9'

(t i:&:> t,t) -: t        i: t, (10&u:)&.>t=: <"_1 a.{~   ?100  $#a.
(t i:&:> t,t) -: t        i: t,~(10&u:)&.>t
(t i:&:> t,t) -: ((10&u:)&.>t) i: t, (10&u:)&.>t
(t i:&:> t,t) -: ((10&u:)&.>t) i: t,~(10&u:)&.>t

(t i:&:> t,t) -: t        i: t, (10&u:)&.>t=: <"_1 a.{~97+?100 3$3
(t i:&:> t,t) -: t        i: t,~(10&u:)&.>t
(t i:&:> t,t) -: ((10&u:)&.>t) i: t, (10&u:)&.>t
(t i:&:> t,t) -: ((10&u:)&.>t) i: t,~(10&u:)&.>t


4!:55 ;:'domerr f g i j k lr sq t UTYPE x y z'


