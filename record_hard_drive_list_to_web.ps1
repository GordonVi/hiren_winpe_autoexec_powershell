# 127.0.0.1 will not work. This is a "fake website" variable
# Copy post.php and list.php to a web server folder
# point the uri to that address

# inject this file into the Hiren WinPE boot ISO under Y:\Programs\record_hard_drive_list_to_web.ps1
# inject/replace the HBCD_PE.INI file into the Hiren WinPE boot ISO

$uri = "http://127.0.0.1/post.php"

$body = @{
	"serial" = $((Get-WmiObject -Class Win32_Bios).SerialNumber)
	"list" = $(get-disk | select number,size,model,serialnumber | convertto-csv -notypeinformation) | out-string
}

$(Invoke-WebRequest -Uri $uri -Method Post -Body $body -usebasicparsing).content

