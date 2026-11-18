Base64, files as Base64 text (RFC 1421, as mail carries them) and back

Base64.Encode file          a viewer with the file in Base64, lines of 84
                            characters
Base64.Decode file ^        writes into file what the selected Base64 text
                            gives (@ as well: the text from the selection on)
Base64.Decode file text     the same from the text file text

Base64.Encode Base64.Tool

Programs: Base64.EncodeFile(F, T) appends the Base64 of the file F to the
text T; Base64.DecodeText(T, beg, F) writes into F what the text T gives from
the position beg, FALSE if the text is not Base64. A character outside Base64
(a blank, a line end) is skipped; any other one ends the text. For strings
there is StringBase64 (base package stringbase64).
