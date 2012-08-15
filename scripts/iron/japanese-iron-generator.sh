#!/bin/bash
#
# Fanboy Adblock Iron Convert script (japanese) v1.1 (03/09/2011)
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

# Split the Opera-specific stuff off... into its own list
#
sed -n '/Japanese-addon/,/Wildcards/{/Wildcards/!p}'  $GOOGLEDIR/opera/urlfilter-jpn.ini > $TESTDIR/urlfilter4.ini

# remove ; from the file
#
sed '/^\;/d' $TESTDIR/urlfilter4.ini > $TESTDIR/urlfilter-jpn.ini

# remove the top line
#
sed '1d'  $TESTDIR/urlfilter-jpn.ini > $TESTDIR/urlfilter4.ini

# Merge with main
#
cat $IRONDIR/adblock.ini $TESTDIR/urlfilter4.ini > $TESTDIR/adblock-jpn.ini

# Merge with tracking
#
cat $IRONDIR/complete/adblock.ini $TESTDIR/adblock-jpn.ini > $TESTDIR/adblock-jpn-stats.ini

# remove any blank lines
#
sed '/^$/d' $TESTDIR/adblock-jpn.ini > $TESTDIR/adblock-jpn2.ini
sed '/^$/d' $TESTDIR/adblock-jpn-stats.ini > $TESTDIR/adblock-jpn-stats2.ini

# remove any wildcards
#
tr -d '*' <$TESTDIR/adblock-jpn2.ini >$IRONDIR/jpn/adblock.ini
tr -d '*' <$TESTDIR/adblock-jpn-stats2.ini >$IRONDIR/jpn/complete/adblock.ini

# Checksum the file (Done)
#
perl $TESTDIR/opera/addChecksum-opera.pl $IRONDIR/jpn/adblock.ini
perl $TESTDIR/opera/addChecksum-opera.pl $IRONDIR/jpn/complete/adblock.ini
rm $IRONDIR/jpn/adblock.ini.gz 
rm $IRONDIR/jpn/complete/adblock.ini.gz

# Zip up files..
#
$ZIP a -mx=9 -y -tgzip $IRONDIR/jpn/adblock.ini.gz $IRONDIR/jpn/adblock.ini > /dev/null 
$ZIP a -mx=9 -y -tgzip $IRONDIR/jpn/complete/adblock.ini.gz $IRONDIR/jpn/complete/adblock.ini > /dev/null
