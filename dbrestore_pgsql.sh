
#!/bin/bash

# print syntax
if [ "$#" != "2" ]; then
        echo "Syntax: $(basename $0) database_name backup_file.sql.xz"
        exit 1
fi


# if not started as root, run this script with sudo
if [ "$(id -u)" != "0" ]; then
        sudo $0 $*
        exit
fi


# extract backup and insert it in one step
unxz --stdout $2 | psql $1

