FF_RetrievePageName()
   {
   DllCall("DdeInitializeW","UPtrP",idInst,"Uint",0,"Uint",0,"Uint",0)

   ; CP_WINANSI = 1004   CP_WINUNICODE = 1200
   hServer := DllCall("DdeCreateStringHandleW","UPtr",idInst,"Str","firefox","int",1200)
   hTopic  := DllCall("DdeCreateStringHandleW","UPtr",idInst,"Str","WWW_GetWindowInfo","int",1200)
   hItem   := DllCall("DdeCreateStringHandleW","UPtr",idInst,"Str","0xFFFFFFFF","int",1200)

   hConv := DllCall("DdeConnect","UPtr",idInst,"UPtr",hServer,"UPtr",hTopic,"Uint",0)
   ; CF_TEXT = 1      CF_UNICODETEXT = 13
   hData := DllCall("DdeClientTransaction","Uint",0,"Uint",0,"UPtr",hConv,"UPtr",hItem,"UInt",1,"Uint",0x20B0,"Uint",10000,"UPtrP",nResult)
   sData := DllCall("DdeAccessData","Uint",hData,"Uint",0,"str")

   DllCall("DdeFreeStringHandle","UPtr",idInst,"UPtr",hServer)
   DllCall("DdeFreeStringHandle","UPtr",idInst,"UPtr",hTopic)
   DllCall("DdeFreeStringHandle","UPtr",idInst,"UPtr",hItem)
   DllCall("DdeUnaccessData","UPtr",hData)
   DllCall("DdeFreeDataHandle","UPtr",hData)
   DllCall("DdeDisconnect","UPtr",hConv)
   DllCall("DdeUninitialize","UPtr",idInst)
   result:=StrGet(&sData,"cp0")
   return result
   }