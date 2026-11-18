MODULE Base64Test;  (* Base64: the vectors of RFC 4648 encoded by EncodeFile, the texts decoded by
  DecodeText into the same bytes again; 769 bytes of every value for the lines and the padding *)

IMPORT Base64, Files, Texts, Out;

VAR checks, fails: LONGINT;

PROCEDURE Check(what: ARRAY OF CHAR; ok: BOOLEAN);
BEGIN
  INC(checks);
  IF ~ok THEN INC(fails); Out.String("FAIL "); Out.String(what); Out.String(" (case "); Out.Int(checks, 0); Out.String(")"); Out.Ln END
END Check;

(* a file with the first n bytes of s *)
PROCEDURE FileOf(s: ARRAY OF CHAR; n: LONGINT): Files.File;
VAR F: Files.File; R: Files.Rider; i: LONGINT;
BEGIN
  F := Files.New(""); Files.Set(R, F, 0); i := 0;
  WHILE i < n DO Files.Write(R, s[i]); INC(i) END;
  RETURN F
END FileOf;

(* the characters of T without the line ends *)
PROCEDURE Plain(T: Texts.Text; VAR s: ARRAY OF CHAR);
VAR R: Texts.Reader; ch: CHAR; i: LONGINT;
BEGIN
  Texts.OpenReader(R, T, 0); Texts.Read(R, ch); i := 0;
  WHILE ~R.eot DO
    IF (ch # 0DX) & (ch # 0AX) & (i < LEN(s) - 1) THEN s[i] := ch; INC(i) END;
    Texts.Read(R, ch)
  END;
  s[i] := 0X
END Plain;

(* F and G hold the same bytes *)
PROCEDURE Same(F, G: Files.File): BOOLEAN;
VAR R, S: Files.Rider; a, b: CHAR; n: LONGINT;
BEGIN
  IF Files.Length(F) # Files.Length(G) THEN RETURN FALSE END;
  Files.Set(R, F, 0); Files.Set(S, G, 0); n := Files.Length(F);
  WHILE n > 0 DO
    Files.Read(R, a); Files.Read(S, b);
    IF a # b THEN RETURN FALSE END;
    DEC(n)
  END;
  RETURN TRUE
END Same;

(* the first n bytes of s encoded give expected, and decoded the same bytes *)
PROCEDURE Vector(s: ARRAY OF CHAR; n: LONGINT; expected: ARRAY OF CHAR);
VAR F, G: Files.File; T: Texts.Text; enc: ARRAY 64 OF CHAR;
BEGIN
  F := FileOf(s, n); NEW(T); Texts.Open(T, "");
  Base64.EncodeFile(F, T); Plain(T, enc);
  Check("encoded", enc = expected);
  G := Files.New("");
  Check("decoded", Base64.DecodeText(T, 0, G) & Same(F, G))
END Vector;

(* 769 bytes: 257 groups of four characters, 21 to a line, one byte in the last group *)
PROCEDURE Bytes;
VAR F, G: Files.File; R: Files.Rider; T: Texts.Text; Rt: Texts.Reader; i, lines: LONGINT; ch: CHAR;
BEGIN
  F := Files.New(""); Files.Set(R, F, 0); i := 0;
  WHILE i < 769 DO Files.Write(R, CHR(i MOD 256)); INC(i) END;
  NEW(T); Texts.Open(T, ""); Base64.EncodeFile(F, T);
  lines := 0; Texts.OpenReader(Rt, T, 0); Texts.Read(Rt, ch);
  WHILE ~Rt.eot DO
    IF ch = 0DX THEN INC(lines) END;
    Texts.Read(Rt, ch)
  END;
  Check("12 line ends", lines = 12);
  Check("1028 characters", T.len = 1028 + 12);
  G := Files.New("");
  Check("769 bytes decoded", Base64.DecodeText(T, 0, G) & Same(F, G))
END Bytes;

PROCEDURE Run*;
BEGIN
  checks := 0; fails := 0;
  Vector("", 0, ""); Vector("f", 1, "Zg=="); Vector("fo", 2, "Zm8="); Vector("foo", 3, "Zm9v");
  Vector("foob", 4, "Zm9vYg=="); Vector("fooba", 5, "Zm9vYmE="); Vector("foobar", 6, "Zm9vYmFy");
  Bytes;
  Out.String("Base64Test: "); Out.Int(checks, 0); Out.String(" checks, "); Out.Int(fails, 0); Out.String(" failed"); Out.Ln
END Run;

END Base64Test.
