/*
	Function: GetHashCode
	
	Returns SHA and MD5 hashes of variables.
	
	Parameters:
		data - variable to be hashed
		len - size in bytes, use -1 to automatically calculate size (default: -1)
		alg_id - any hash identifier <http://msdn2.microsoft.com/en-us/library/aa375549.aspx> e.g. MD5: 0x8003, SHA: 0x8004 (default: 0x8003)
	
	About: License
		- Version 1.0 by Sean, modified by Titan
		- GNU General Public License 3.0 or higher <http://www.gnu.org/licenses/gpl-3.0.txt>

*/

GetHashCode(ByRef data, len = -1, alg_id = 0x8003) {
	DllCall("advapi32\CryptAcquireContextA", "UIntP", hProv, "UInt", 0, "UInt", 0, "UInt", 1, "UInt", 0) ; PROV_RSA_FULL = 1
	DllCall("advapi32\CryptCreateHash", "UInt", hProv, "UInt", alg_id, "UInt", 0, "UInt", 0, "UIntP", hHash)
	DllCall("advapi32\CryptHashData", "UInt", hHash, "UInt", &data, "UInt", len < 0 ? VarSetCapacity(data) : len, "UInt", 0)
	
	ssz := VarSetCapacity(sz, 4, 0)
	DllCall("advapi32\CryptGetHashParam", "UInt", hHash, "UInt", 4, "UIntP", sz, "UIntP", ssz, "UInt", 0)
	VarSetCapacity(HashVal, sz, 0)
	DllCall("advapi32\CryptGetHashParam", "UInt", hHash, "UInt", 2, "UInt", &HashVal, "UIntP", sz, "UInt", 0)
	
  BinaryToString(str, HashVal, false, sz)
  
	DllCall("advapi32\CryptDestroyHash", "UInt", hHash)
	DllCall("advapi32\CryptReleaseContext", "UInt", hProv, "UInt", 0)
	Return, str
}

#Include Binary-String.ahk
