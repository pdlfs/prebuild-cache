#!/bin/sh -e
#
# prebuild-cache.sh  build a minimal initial cache for travis to reduce runtime
# 22-Jan-2017  chuck@ece.cmu.edu
#

#
# ensure we have the environment we need
#
if [ x$TRAVIS_OS_NAME = x ]; then
    echo missing TRAVIS_OS_NAME variable
    exit 1
fi
if [ x$CC = x ]; then
    echo missing CC variable
    exit 1
fi

#
# build a fake cache directory and tmp working area, checkout pdlfs-common
#
rm -rf ${HOME}/cache
mkdir -p ${HOME}/cache
mkdir -p ${HOME}/tmp
cd ${HOME}/tmp

rm -rf pdlfs-common
git clone https://github.com/pdlfs/pdlfs-common.git
cd pdlfs-common

#
# now run 
#
export CACHE_PREBUILD=1
./cmake/travis-checkcache.sh

#
# generate tar file
#
target=cache-${TRAVIS_OS_NAME}-${CC}.tgz
cd ${HOME}
tar czf $target cache

#
# upload result (gated, we don't normally leave the dir write enabled)
#
curl -T $target -u ftp:ftp ftp://ftp.pdl.cmu.edu/incoming/pdlfs/$target

#
# done!
#
exit 0
