# Ramdisks for the masses

Create readwrite ramdisks from other ones and also a reliable way to
open/close them.

## Usage

To just reevaluate a ramdisk:

	make RAMDISK_OLD=<your old ramdisk>

To open a ramdiskand tamper with it:

	$ ./ramdisk.sh open [<ramdisk file, defaults to /uramdisk.image.gz>]
	.... tamper in ./ramdisk-mnt  probably using sudo...
	$ ./ramdisk.sh close [<ramdisk file, defaults to /uramdisk.image.gz>]

That will produce a uramdisk and say where with:

	Created proper ramdisk!: <valid ramdisk>

At some pount it will say something along the lines of

	...
	Created proper ramdisk!: /homes/ggkitsas/Projects/ramdisk-hacking/uramdisk.image.out.gz
	...

To test it do:

	$ ls
	Makefile  ramdisk.image.gz  ramdisk.img  ramdisk-mnt  ramdisk.sh  README.md  tmp
	$ ./ramdisk.sh open /homes/ggkitsas/Projects/ramdisk-hacking/uramdisk.image.out.gz
	1326738+0 records in
	1326738+0 records out
	5306952 bytes (5.3 MB) copied, 3.31165 s, 1.6 MB/s
	$ ls ramdisk-mnt
	bin  etc   lib       linuxrc     mnt  proc    root  sys  update_qspi.sh  var
	dev  home  licenses  lost+found  opt  README  sbin  tmp  usr
	$ touch ramdisk-mnt/test
	touch: cannot touch `ramdisk-mnt/test': Permission denied
	$ sudo touch ramdisk-mnt/test
	$ ls ramdisk-mnt
	bin  etc   lib       linuxrc     mnt  proc    root  sys   tmp             usr
	dev  home  licenses  lost+found  opt  README  sbin  test  update_qspi.sh  var
	$ ./ramdisk.sh close /homes/ggkitsas/Projects/ramdisk-hacking/uramdisk.image.out.gz
	Image Name:
	Created:      Fri May 30 18:56:35 2014
	Image Type:   ARM Linux RAMDisk Image (gzip compressed)
	Data Size:    5306934 Bytes = 5182.55 kB = 5.06 MB
	Load Address: 00000000
	Entry Point:  00000000
	Created proper ramdisk!: /homes/ggkitsas/Projects/ramdisk-hacking/uramdisk.image.out.out.gz
	$ ./ramdisk.sh open /homes/ggkitsas/Projects/ramdisk-hacking/uramdisk.image.out.out.gz
	1326733+1 records in
	1326733+1 records out
	5306934 bytes (5.3 MB) copied, 3.26808 s, 1.6 MB/s
	$ ls ramdisk-mnt
	bin  etc   lib       linuxrc     mnt  proc    root  sys   tmp             usr
	dev  home  licenses  lost+found  opt  README  sbin  test  update_qspi.sh  var
	$ sudo umount ./ramdisk-mnt
