print("hello world!")

;  - basic arithmetic
a = 1
b = 2

print(a+b)

;   - Drawing a default cylindrical equidistant map
wksfilename = "maponly"
wksfiletype = "pdf"
wks  = gsn_open_wks(wksfiletype,wksfilename)     ; open a ps file
plot = gsn_csm_map_ce(wks,False)        ; draw global map
delete(wks)  ; must close the workstation before plot file can be opened
; this will open the map in Preview on OS X
; untested on Windows and Linux
system("open "+wksfilename+"."+wksfiletype)

; exit command must be present for atom-script file-based mode to function properly
exit
