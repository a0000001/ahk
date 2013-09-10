/*
	Function: BinaryToString
	
	Converts binary into a formatted string.
	Note: requires Windows Vista or XP with .NET 2.0+
	
	Parameters:
		str - output string variable
		bin - variable containing binary data
		base64 - true to use base64 encoding, otherwise hexadecimal conversion
		sz - number of bytes to convert, leave blank or use -1 to convert entire variable
	
	Function: StringToBinary
	
	Parameters:
		bin - output binary variable
		str - variable containing string to convert
		base64 - true to use base64 encoding, otherwise hexadecimal conversion
		sz - number of bytes to convert, leave blank or use -1 to convert entire variable
	
	About: License
		- Version 1.1 by Titan.
		- Licenced under GNU GPL <http://creativecommons.org/licenses/GPL/2.0/>.

*/

BinaryToString(ByRef str, ByRef bin, base64 = true, sz = -1) {
	cp := VarSetCapacity(str, VarSetCapacity(bin) * (base64 ? 1.42 : 3.125))
	DllCall("Crypt32.dll\CryptBinaryToStringA", "UInt", &bin
		, "UInt", sz > 0 ? sz : VarSetCapacity(bin)
		, "UInt", base64 ? 1 : 4, "UInt", &str, "UInt", &cp), VarSetCapacity(str, -1)
	If !base64
		str := RegExReplace(str, "S)\s|0*$")
}

StringToBinary(ByRef bin, ByRef str, base64 = true, sz = -1) {
	cp := VarSetCapacity(bin, StrLen(str) / (base64 ? 1.42 : 2), fb)
	DllCall("Crypt32.dll\CryptStringToBinaryA", "UInt", &str
		, "UInt", sz > 0 ? sz : StrLen(str), "UInt", base64 ? 7 : 8
		, "UInt", &bin, "UInt", &cp, "UInt", 0, "UInt", 0), VarSetCapacity(bin, -1)
}
