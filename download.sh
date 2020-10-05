#!/bin/zsh
# vim: sw=4

set -e
#set -x

fail()
{
    print "FATAL: $@"
    exit 1
}

info()
{
    print "INFO: $@"
}

do_county()
{
    for url in ${root}${country}linux.7z ${root}${country}.exe; do
	print ${url}
	if curl --etag-save tmp.tag --silent --head --fail ${url} > /dev/null; then
	    info "using ${url} for ${country}"
	    file=dl/${url##*/}
	    tag=dl/${url##*/}.tag
	    if cmp tmp.tag ${tag} && [ -r ${file} ]; then
		info "using existing file ${file}"
	    else
		info "downloading ${file}"
		curl --etag-save ${tag} --fail ${url} -o ${file}
	    fi
	    rm -f tmp.tag
	    return
	fi
    done
    rm -f tmp.tag
    fail "could not determine URL for ${country}"
}

[ -d dl ] || btrfs sub create dl

base=http://ftp.gwdg.de/pub/misc/openstreetmap/openmtbmap/odbl

countries=(germany sweden denmark norway austria switzerland)
for root in ${base}/mtb ${base}/velomap/velo; do
    for country in ${countries}; do
	do_county
    done
done

countries=(baden-wuerttemberg)
for root in ${base}/germany/mtb ${base}/velomap/germany/velo; do
    for country in ${countries}; do
	do_county
    done
done
