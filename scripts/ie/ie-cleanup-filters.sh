#!/bin/bash
#
# Fanboy IE Cleanup (31/07/2012)
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
    mkdir /tmp/ieramdisk/subscriptions/temp
fi

# Variables
#
MAINDIR="/var/www/adblock"
GOOGLEDIR="/home/fanboy/google/fanboy-adblock-list"
ZIP="/usr/local/bin/7za"
IEDIR="/tmp/ieramdisk"
SUBS="/tmp/ieramdisk/subscriptions"
TESTDIR="/tmp/ramdisk"
SUBSTEMP="/tmp/ieramdisk/subscriptions/temp"

# Now remove filters that cause issues in IE (and false positives)
#
sed -i '10,20000{/\#/d}' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '10,20000{/#/d}' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d atdmt.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d doubleclick.net/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d 247realmedia.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d googlesyndication.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d scorecardresearch.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d oascentral.thechronicleherald.ca/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d au.adserver.yahoo.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d adserver.yahoo.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d skimlinks.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d ad-emea.doubleclick.net/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d ad.au.doubleclick.net/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d spotxchange.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/adf.ly/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d ad-emea.doubleclick.net/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d g.doubleclick.net/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d pagead2.googlesyndication.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d partner.googleadservices.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d ads.yimg.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d ad.ca.doubleclick.net/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d ad.doubleclick.net/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d zedo.com/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
# http://hg.fanboy.co.nz/rev/5760d7c3afb3
sed -i '/&adsType=/d' $SUBSTEMP/fanboy-noele.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl

# Now remove filters that cause issues in IE (and false positives)
#
sed -i '9,20000{/\#/d}' $SUBSTEMP/fanboy-tracking.tpl
sed -i '9,20000{/#/d}' $SUBSTEMP/fanboy-tracking.tpl

sed -i '/Do-Not-Track/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/donottrack/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/-d nbcudigitaladops.com/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/-d dw.com.com/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d dhl./d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d server-au.imrworldwide.com/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d secure-us.imrworldwide.com/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d revsci.net/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d js.revsci.net/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/+d easy.box/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl
sed -i '/- \/quant.js/d' $SUBSTEMP/fanboy-tracking.tpl $SUBSTEMP/fanboy-ultimate-ie.tpl $SUBSTEMP/fanboy-complete-ie.tpl

# Copy back
#
mv -f $SUBSTEMP/*.tpl $SUBS