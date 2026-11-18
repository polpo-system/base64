# base64

Base64 of ETH Oberon for [polpo](https://github.com/polpo-system/polpo): files as Base64 text
(RFC 1421, as mail carries them) and back, in the desktop. `Base64.Encode file` opens a viewer with
the file in Base64, `Base64.Decode file ^` writes the file that the selected text gives. Programs
call `Base64.EncodeFile(F, T)` and `Base64.DecodeText(T, beg, F)`. Strings are encoded by
`StringBase64`, a base package of polpo.

```
portia.Install base64
```

## What is here

    src/Base64.Mod           Encode, Decode, EncodeFile, DecodeText
    tools/Base64.Tool        the commands, with an example
    test/Base64Test.Mod

The source comes from ETH Linux Oberon (OLR, 2017-06-18), the same file as in Native Oberon 2.3.7:
the first commit has it unchanged, the second as plain text. One change since: a character above
127 in a decoded text ends the Base64 text (it stopped with an index trap). It compiles with all of
polpo's compilers (x86, ARM, ARMv7, RISC-V, MIPS in both byte orders, PowerPC, 68020).

## Tests

    Base64Test.Run       18 checks: the vectors of RFC 4648 encoded and decoded again, 769 bytes
                         of every value (lines and padding), a character above 127; it needs the
                         desktop's display

The license is GPL-3 (`LICENSE`); the code comes from ETH Oberon, whose license (`LICENSE.ETH`)
asks to keep its copyright notice and conditions, which `LICENSE.ETH` does.
