#!/bin/bash
#
# Fanboy Adblock Iron Convert script v1.1 (03/09/2011)
# Dual License CCby3.0/GPLv2
# http://creativecommons.org/licenses/by/3.0/
# http://www.gnu.org/licenses/gpl-2.0.html
#

# Creating a 10Mb ramdisk Temp storage...
#
if [ ! -d "/tmp/iron/" ]; then
    rm -rf /tmp/iron/
    mkdir /tmp/iron; chmod 777 /tmp/iron
    mount -t tmpfs -o size=10M tmpfs /tmp/iron/
fi

# Variables
#
MAINDIR="/var/www/adblock/opera"
IRONDIR="/var/www/adblock/iron"
GOOGLEDIR="/home/fanboy/google/fanboy-adblock-list"
ZIP="/usr/local/bin/7za"
TESTDIR="/tmp/iron"


# remove ; from the file
#
sed '/^\;/d' $MAINDIR/complete/urlfilter.ini > $TESTDIR/urlfilter-stats.ini

# Split the Opera-specific stuff off... into its own list
#
sed -n '/Stats list (Opera)/,/Wildcards/{/Wildcards/!p}' $TESTDIR/urlfilter-stats.ini > $TESTDIR/urlfilter3.ini

# remove the top line
#
sed '1d' $TESTDIR/urlfilter3.ini > $TESTDIR/urlfilter-stats.ini

# Merge with tracking
#
cat $IRONDIR/adblock.ini $TESTDIR/urlfilter-stats.ini > $TESTDIR/adblock-stats.ini

# remove any blank lines
#
sed '/^$/d' $TESTDIR/adblock-stats.ini > $TESTDIR/adblock2-stats.ini

# remove any wildcards
#
tr -d '*' <$TESTDIR/adblock2-stats.ini >$IRONDIR/complete/adblock.ini

# Checksum the file (Done)
#
perl $IRONDIR/addChecksum-opera.pl $IRONDIR/complete/adblock.ini
rm $IRONDIR/complete/adblock.ini.gz

# echo "adblock.ini copied" > /dev/null
#
$ZIP a -mx=9 -y -tgzip $IRONDIR/complete/adblock.ini.gz $IRONDIR/complete/adblock.ini > /dev/null
 