#!/bin/sh

# see http://help.transifex.net/features/client/index.html
# use this script to initial setup a new geoserver branch for transifex
# Parameters : a version info 
#			is required to distinguish different projects on transifex server results into geoserver_<version> project
#

error () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || error "1 argument required, $# provided"

GS_VERSION=$1
tx init
tx set --auto-remote https://www.transifex.net/projects/p/geoserver_$GS_VERSION

WEB_MODULES=( core demo gwc security wms wfs wcs )

for i in "${WEB_MODULES[@]}"
do
	p_path=src/web/$i/src/main/resources
	source_file=$p_path/GeoServerApplication.properties
	if [[ -f $source_file ]]
	then
		echo "FILE exists" 
		echo "$source_file"
		file_filter="$p_path/GeoServerApplication_<lang>.properties"
		echo $file_filter
		tx set --auto-local -r geoserver_$GS_VERSION.$i -s en $file_filter -f $source_file --execute
	fi
done

# upload source files
tx push --source --skip

# upload tranlations 
tx push --translations --skip
