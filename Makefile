push-to-devel:
	rsync -ave ssh usr-lib-one-tm_commands/gfs2clvm/ 	root@cloudmgmt.etn:/usr/lib/one/tm_commands/gfs2clvm/
	rsync -ave ssh var-lib-one-remotes-image-fs/ 		root@cloudmgmt.etn:/var/lib/one/remotes/image/fs/

