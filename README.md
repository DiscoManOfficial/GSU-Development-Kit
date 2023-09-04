GSU DEV KIT
-----------------------------------------------------
   by DiscoMan                 Version 1.98

The new way of doing hacking, the GSU Dev Kit enables
Super FX on your Super Mario World ROM.
It also prepares your ROM to use Super FX in the
best way possible.
With minor modifications, you can use this kit in a
homebrew even!

Features
-----------------------------------------------------

 - It features Super FX's CPU core with 21.47 MHz speed,
which is eight times faster than SNES. Super FX can run
parallel with SNES CPU making the game 10 times faster!

 - Pipelining system. With this system, you can sandwich
several instructions as they get loaded and executed, meaning
efficient processing of data.

 - Bitmap support. Allows the user to create any type of bitmap
that can be read by SNES PPU format, this allows for highly advanced
2D graphics or 3D.

 - Cache RAM allows Super FX to operate without need for ROM/RAM.
Also, it allows for 1 cycle opcode execution.

 - High speed arithmetic support, it even surpasses DSP-1 when it comes to
SNES to CPU (and vice versa) communication.
 
Changes
-----------------------------------------------------

When patched, the following changes will take effect:

 - Super FX will undertake heavy operations that SNES
alone can't handle, this will reduce slowdowns and lags
caused by repetitive and/or slow operations such as loops.

 - Patches like VWF dialogues will run thrice as fast, taking
in account Super FX's efficiency, this will allow huge possibilities.
Remember to convert the patches as needed!

As one can see, those changes RAM to match even addresses, improving Super FX's
operations. (The changed RAM Map is presented down at this Readme, be sure to access
in order to understand Super FX's new mappings!)

Warnings
-----------------------------------------------------

GSU Dev Kit is probably the most highly advanced and complex
patch in existence, the reason why is because that most routines
have been rewritten to use Super FX ASM language, which isn't
similar to SNES one. Therefore, high caution should be taken
when using patches or tools that modifies areas that this patch
modifies.

However, this Dev Kit allows the user/programmer to successfully
edit/create new routines on top of those modified, allowing new
works without the need of patches and hijacks. It also makes easier
to pinpoint hijacks and then adapt routines to Super FX without
the need of supplemental help.

This patch remaps several addresses and therefore caution
should be done about compatibility, I'm personally converting
several patches to either GSU format or GSU compatible format
for uses, the link will be down this readme.

Some emulators won't properly emulate some custom routines,
mainly because of lack of accuracy.

Also, contrary to popular belief, Super FX ROMs CAN reach 8MB in size!
According to patents and Nintendo Development Book, only Super FX
is limited to 2MB ($00-$3F being Normal ROM area and $40-$5F being the 'HiROM Mirror' area)
aside from banks $70-$71, that being Super FX's RAM area.
SNES on the other hand is virtually unlimited, though on hardware bankswitch (MAD-1?) SNES can access areas
beyond Super FX control, that area is called Additional ROM (or SNES CPU ROM) aside from Additional Backup RAM ($78-$79).
One using Higan or schematics to modify cartridges can implement those extra features for the Super FX ROM,
overcoming the 2MB limit. Why Nintendo didn't do that? Stop making games way expensive, nowadays with hacking and knowledge, one can extend
the capabilities of the poor underrated Super FX chip and ROM/Flash chips are pretty cheaper.

Usage
-----------------------------------------------------

Super FX can be quite troubling when dealing with it,
mostly due to size limitations and harder ASM language
but once you get the logic to work, you can do unlimited
stuff with it.

To get started, grab your clean, (U) 1.0 SMW ROM, open
Lunar Magic and expand to at a maximum of 2MB.

Using asar, simply patch 'superfx.asm' in your ROM and open
it in any emulator to test.

If you did everything right, Snes9X/ZSNES will respectively
display ROM+RAM+SRAM+Super FX or Type: Super FX

F.A.Q
-----------------------------------------------------

 Q: Is it really hard to work with Super FX?

 A: At the start, it's very hard to get the grip of how
the ASM language and logic works on Super FX, considering
the pipelining system, cache, bitmap emulation and so on...
But after getting used to that, everything should be very clear
and easy for you. ^^

 Q: I don't understand Super FX ASM, what could I do?
 
 A: Well, I included a link for my Super FX programming tutorial
you can read it and study it's contents to learn how to program
for Super FX, as said above, while it's a bit hard and tricky to learn
it's pretty much doable! There are examples in this very own development
kit for you to study, want a hint? Check every Super FX ASM routines designed
for SMW's engine, almost all files have detailed comments with their respective
SNES codes, allowing a better comparison and visualization. If lack of understanding
is the issue you can't get Super FX ASM, those comments will surely kick in!

 Q: Is Super FX incompatible with my stuff?
 
 A: At the time, unfortunately since developing stuff alone strains heavily on a programmer's
back but never fear! I designed a way to know exactly if something will break or not!
Let's take Lunar Magic for example, we all know Lunar Magic hijacks certain areas of the ROM
to implement it's ASM code, however, the code is mostly SNES ASM. Knowing this, the reworked
engine, zeroes all unused routines, allowing tools to "hijack" the empty area, allowing the user
to easily pinpoint where the ASM will be placed without anything breaking! You can easily study the code
and recreate it's own version using Super FX ASM without much worry! This is how you can easily
turn your works compatible with Super FX!

Programming
-----------------------------------------------------

Unlike Super FX Pack, this development kit is way more complex
because of the various RAM remapping and several routines converted
especially for Super FX.

That means that in order to make stuff compatible with Super FX,
several instances should be taken in mind:

DP values from $XX:0000-$XX:1FFF to $XX:6000-$XX:7FFF
Remembering that XX must be from $00-$3F and from $80-$BF

-----------------------------------------------------

Considering that you know how ROM/SRAM works in the ROM,
you may be asking, how to make Super FX work?

Entering Super FX mode is a piece of cake.
Store the 16-bit address to Accumulator (A) and the
8-bit bank on Index Y (Y), after that just JSR (or JMP)
to $1E80, i.e.:

```
REP #$20
LDY.b #Label>>16		;\ Put address in the proper place...
LDA.w #Label			;/
JSR $1E80				; Call Super FX and wait.
[...]					; *other code*

arch superfx			; REMEMBER! Use asar to easily create routines
						; using Super FX's ASM language
Label:
[...]					; Code goes here
STOP					; Finish processing data.
arch 65816				; Return to SNES ASM mode
```

When you switch to Super FX side, things works way differently:

 - You can't access the PPU and CPU registers,
which are located at $2100-$21FF, $4200-$42FF and around $4000 too.

 - You can't access WRAM (Work RAM) in banks $7E and $7F.
Addresses ranging from $0000-$1FFF can only be accessed on SNES side.
Any attempt of doing so in Super FX side means to load from $7x0000 to $7x1FFF
depending of your RAMB setup. (7x ranging from 70 to 71.)

 - You can access the $700000-$71FFFF range, which is the Super FX's
BW-RAM. (The manual states Game Pak RAM but it can act as SRAM as well.)

 - The CPU runs 8x times faster than usual, specifically at 21.47 MHz
instead of 2.68 or 3.56 MHz (FastROM).

Unfortunately, unlike SA-1, Super FX don't have registers for multiplication
and division, let alone DMA operations BUT if you had read from the above explanation
you can easily set up routines that don't need waiting and you can do other stuff
while calculations are being done and they aren't slow either, multiplication on Super FX
takes 1 cycle, while division you have to code yourself (unfortunately).

Super FX can't rely on DMA (since it don't have any DMA operation) but it have ROM/RAM buffering
which means that for example, Super FX while is getting ROM data, it's saving data on RAM in multiple
operations, making faster for plotting operations or general related ones.

Unlike SA-1, Super FX can't directly interrupt the CPU program
to get data when needed, although it can do IRQ when it's own processing
is done but Super FX have a very interesting function that allows
sidetracking on SNES, meaning that Super FX can be interrupted while SNES
provides Super FX anything it needs!

How can this be useful? When you can't access something from Super FX side,
of course. Using this method, you can make a quick access on something
from SNES side, then come back with the value. Example: Super FX wants to
read from an APU port, but logically, it can't access it. To make it accessible,
stop processing on Super FX, then call the the SNES so you can read from the APU
port and then send the value to Super FX. See below:

```
[...]
STOP			; I need APU ports, can't access, temporarily halt processing
NOP				; Prefetch dummy but don't execute it
[...]			; Read below: After Super FX is called again (using R15 data which is after NOP)
				; It'll start processing after that NOP, simply as that
arch 65816
LDA $2140				; \ Read $2140-$2143
STA $3000				; | and save in $3100-$3106 (even)
LDA $2141				; | Save in registers R0-R3
STA $3002				; |
LDA $2142				; |
STA $3004				; |
LDA $2143				; |
STA $3006				; /
JSR $1Exx				;<> Continue Super FX routine...
```

Using this method you can get rid of almost all Super FX
limitations, but remember SNES have a slow CPU,
calling it too many times, means that you may waste some time.

WARNING: Unlike the RON/RAN method, it is ADVISABLE you use the STOP
opcode if you want to get data and use it later on your routine. Why?
By simply clearing the flags, you stop Super FX but you don't know exactly
where Super FX is halted, therefore you can easily break any operations Super FX
may be doing at the time, using RON/RAN method it's risky and only advisable if you
know exactly what you are doing!

Super FX Tutorial: http://www.smwcentral.net/?p=viewthread&t=81548
-----------------------------------------------------

Credits
-----------------------------------------------------

Without these people, it would have been impossible for the GSU Dev Kit 
to be created perfectly:

 - Mayonnai
 - Mirann
 - anonimzwx
 - K3fka
 - Vitor Vilela
