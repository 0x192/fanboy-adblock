#!/bin/bash
#
# Fanboy Japanese IE Convert script v1.2 (17/04/2011)
# Dual License CCby3.0/GPLv2
# http://creativecommons.org/licenses/by/3.0/
# http://www.gnu.org/licenses/gpl-2.0.html
#

# Creating a 10Mb ramdisk Temp storage...
#
if [ ! -d "/tmp/ieramdisk/" ]; then
    rm -rf /tmp/ieramdisk/
    mkdir /tmp/ieramdisk; chmod 777 /tmp/ieramdisk
    mount -t tmpfs -o size=10M tmpfs /tmp/ieramdisk/
    cp -f /home/fanboy/google/fanboy-adblock-list/scripts/ie/combineSubscriptions.py /tmp/ieramdisk/
    mkdir /tmp/ieramdisk/subscriptions
fi


# Clear out any old files lurking
#
rm -rf $IEDIR/*.txt $SUBS/*
cd $IEDIR

# Copy TPL (Microsoft IE9) Script
#
# cp -f /root/maketpl.pl $IEDIR

####### Placeholder ########
# Cleanup fanboy-jpn-addon.txt (remove the top 8 lines) 
#
# sed '1,8d' $GOOGLEDIR/ie/fanboy-jpn-addon.txt > $IEDIR/fanboy-jpn-addon.txt

# Take out the element blocks from the list
#
sed -n '/Adblock Plus/,/Japanese Generic/{/Japanese Generic/!p}' $GOOGLEDIR/firefox-regional/fanboy-adblocklist-jpn.txt > $IEDIR/fanboy-japanese.txt

# Remove ~third-party
#
sed -i '/~third-party/d' $IEDIR/fanboy-japanese.txt

####### Placeholder ########
# Merge with Google-code (IE adblock addon)
#
# cat $IEDIR/fanboy-japanese.txt $IEDIR/fanboy-jpn-addon.txt > $IEDIR/fanboy-jpn-merged.txt
# mv -f $IEDIR/fanboy-jpn-merged.txt $IEDIR/fanboy-japanese.txt

####### Placeholder ########
# Remove Old files
#
# rm -rf $IEDIR/fanboy-jpn-addon.txt

# Generate .tpl IE list
#
# perl $IEDIR/maketpl.pl &> /dev/null
python $GOOGLEDIR/scripts/ie/combineSubscriptions.py $IEDIR $SUBS

# Now remove filters that cause issues in IE (and false positives)
#
sed -i '9,20000{/\#/d}' $SUBS/fanboy-japanese.tpl
sed -i '9,20000{/#/d}' $SUBS/fanboy-japanese.tpl

# Remove last line of file
#
sed '$d' $SUBS/fanboy-japanese.tpl > $SUBS/fanboy-japanese-trim.tpl
mv -f $SUBS/fanboy-japanese-trim.tpl $SUBS/fanboy-japanese.tpl

# Remove old gz file
#
rm -f $SUBS/fanboy-japanese.tpl*.gz

# Re-compress newly modified file
#
$ZIP a -mx=9 -y -tgzip $SUBS/fanboy-japanese.tpl.gz $SUBS/fanboy-japanese.tpl > /dev/null

# Now copy finished tpl list to the website.
#
cp -f $SUBS/fanboy-japanese*.tpl* $MAINDIR/ie/
