Create a Bootable ISO or CD that will execute a custom POwershell Script in a WinPE environment.

This uses:

- Hiren's WinPE Boot CD - https://www.hirensbootcd.org/
- PHP scripts on a PHP enabled web server

The idea is to do a zero touch ISO boot and have it record all physical hard drives to a PHP script.

---

Step 1)
Copy post.php and list.php to a web server folder (This requires a server that is running PHP and has file write access)

Step 2)
Open record_hard_drive_list_to_web.ps1
127.0.0.1 will not work. This is a "fake website" variable
Point the $uri to the web address of post.php from step 1

Step 3)
inject this modified file into the Hiren WinPE boot ISO under Y:\Programs\record_hard_drive_list_to_web.ps1

Step 4)
inject/replace the HBCD_PE.INI file into the Hiren WinPE boot ISO found at the root of the ISO file system.
