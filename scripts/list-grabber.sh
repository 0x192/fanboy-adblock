#!/bin/bash
#
# Fanboy Adblock list grabber script v1.5 (14/02/2012)
# Dual License CCby3.0/GPLv2
# http://creativecommons.org/licenses/by/3.0/
# http://www.gnu.org/licenses/gpl-2.0.html
#

# Creating a 20Mb ramdisk Temp storage...
#
if [ ! -d "/tmp/ramdisk/" ]; then
    rm -rf /tmp/ramdisk/
    mkdir /tmp/ramdisk; chmod 777 /tmp/ramdisk
    mount -t tmpfs -o size=20M tmpfs /tmp/ramdisk/
    mkdir /tmp/ramdisk/opera/
fi
if [ ! -d "/tmp/ramdisk/opera/" ]; then
    mkdir /tmp/ramdisk/opera/
fi

# Variables for directorys
#
MAINDIR="/var/www/adblock"
GOOGLEDIR="/home/fanboy/google/fanboy-adblock-list"
TESTDIR="/tmp/ramdisk"
ZIP="nice -n 19 /usr/local/bin/7za"
NICE="nice -n 19"
SHRED="nice -n 19 /usr/bin/shred"

# Grab Mercurial Updates
#
cd /home/fanboy/google/fanboy-adblock-list/
$NICE /usr/local/bin/hg pull
$NICE /usr/local/bin/hg update

# Copy Popular Files into Ram Disk
#
$SHRED -n 5 -z -u  $TESTDIR/opera/urlfilter.ini $TESTDIR/opera/urlfilter-stats.ini
cp -f $GOOGLEDIR/scripts/addChecksum.pl $GOOGLEDIR/scripts/addChecksum-opera.pl $TESTDIR
cp -f $GOOGLEDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-stats.ini $TESTDIR/opera/

# Make sure the shell scripts are exexcutable, all the time..
#
chmod a+x $GOOGLEDIR/scripts/ie/*.sh $GOOGLEDIR/scripts/iron/*.sh $GOOGLEDIR/scripts/*.sh $GOOGLEDIR/scripts/firefox/*.sh $GOOGLEDIR/scripts/combine/*.sh

# Main List
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/fanboy-adblocklist-current-expanded.txt ]
then
  if diff $GOOGLEDIR/fanboy-adblocklist-current-expanded.txt $MAINDIR/fanboy-adblock.txt >/dev/null ; then
    echo "No changes detected: fanboy-adblock.txt" > /dev/null
  else
    # Make sure the old copy is cleared before we start
    rm -f $TESTDIR/fanboy-adblock.txt.gz $TESTDIR/fanboy-adblock.txt
    # Copy to ram disk first. (quicker)
    cp -f $GOOGLEDIR/fanboy-adblocklist-current-expanded.txt $TESTDIR/fanboy-adblock.txt
    # Re-generate checksum
    perl $TESTDIR/addChecksum.pl $TESTDIR/fanboy-adblock.txt
    cp -f $TESTDIR/fanboy-adblock.txt $MAINDIR/fanboy-adblock.txt
    # Compress file in Ram disk
    $ZIP a -mx=9 -y -tgzip $TESTDIR/fanboy-adblock.txt.gz $TESTDIR/fanboy-adblock.txt > /dev/null
    # Clear Webhost-copy before copying
    rm -f $MAINDIR/fanboy-adblock.txt.gz
    # Now Copy over GZip'd list
    cp -f $TESTDIR/fanboy-adblock.txt.gz $MAINDIR/fanboy-adblock.txt.gz
    # perl $TESTDIR/addChecksum.pl $TESTDIR/firefox-expanded.txt-org2
    # cp -f $TESTDIR/firefox-expanded.txt-org2 $MAINDIR/fanboy-adblock.txt
    # cp -f $GOOGLEDIR/fanboy-adblocklist-current-expanded.txt $MAINDIR/fanboy-adblock.txt
    # cp -f $TESTDIR/fanboy-adblocklist-current-expanded.txt $MAINDIR/fanboy-adblock.txt

    # The Dimensions List
    #
    $NICE $GOOGLEDIR/scripts/firefox/fanboy-dimensions.sh
    
    # The Adult List
    #
    $NICE $GOOGLEDIR/scripts/firefox/fanboy-adult.sh

    # The P2P List
    #
    $NICE $GOOGLEDIR/scripts/firefox/fanboy-p2p.sh

    # Seperate off CSS elements for Opera CSS
    #
    $NICE $GOOGLEDIR/scripts/firefox/fanboy-element-opera-generator.sh
    
    # Seperate off Elements
    #
    $NICE $GOOGLEDIR/scripts/firefox/fanboy-noele.sh
    
    # Combine (Czech)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-czech.sh
    # Combine (Espanol)
		$NICE $GOOGLEDIR/scripts/combine/firefox-adblock-esp.sh
    # Combine (Russian)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-rus.sh
    # Combine (Japanese)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-jpn.sh
    # Combine (Swedish)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-swe.sh
    # Combine (Chinese)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-chn.sh
    # Combine (Vietnam)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-vtn.sh
    # Combine (Vietnam)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-krn.sh
    # Combine (Turkish)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-turk.sh
    # Combine (Italian)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-ita.sh
    # Combine (Polish)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-pol.sh
    # Combine Regional trackers
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Combine
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-tracking.sh
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-merged.sh
    # Combine (Main+Tracking+Enhanced) and Ultimate (Main+Tracking+Enhanced+Annoyances)
    $NICE $GOOGLEDIR/scripts/combine/firefox-adblock-ultimate.sh
    echo "Updated: fanboy-adblock.txt" > /dev/null
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-current-expanded.txt size is zero, please fix. " mp3geek@gmail.com < /dev/null
fi

# Tracking
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/fanboy-adblocklist-stats.txt ]
then
  if diff $GOOGLEDIR/fanboy-adblocklist-stats.txt $MAINDIR/fanboy-tracking.txt >/dev/null ; then
     echo "No Changes detected: fanboy-tracking.txt"
   else
    # echo "Updated: fanboy-tracking.txt"
    # Clear old list
    rm -f $TESTDIR/fanboy-tracking.txt.gz $TESTDIR/fanboy-tracking.txt
    # Copy list from repo to RAMDISK
    cp -f $GOOGLEDIR/fanboy-adblocklist-stats.txt $TESTDIR/fanboy-tracking.txt
    # Re-generate checksum
    perl $TESTDIR/addChecksum.pl $TESTDIR/fanboy-tracking.txt
    # GZip
    $ZIP a -mx=9 -y -tgzip $TESTDIR/fanboy-tracking.txt.gz $TESTDIR/fanboy-tracking.txt > /dev/null
    # Clear Webhost-copy before copying and Copy over GZip'd list
    cp -f $TESTDIR/fanboy-tracking.txt $MAINDIR/fanboy-tracking.txt
    rm -f $MAINDIR/fanboy-tracking.txt.gz
    cp -f $TESTDIR/fanboy-tracking.txt.gz $MAINDIR/fanboy-tracking.txt.gz
    # Now combine with international list
    sh /etc/crons/hg-grab-intl.sh
    # Generate IE script
    $GOOGLEDIR/scripts/ie/tracking-ie-generator.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-tracking.sh
    $GOOGLEDIR/scripts/combine/firefox-adblock-merged.sh
    # Combine (Main+Tracking+Enhanced) and Ultimate (Main+Tracking+Enhanced+Annoyances)
    $GOOGLEDIR/scripts/combine/firefox-adblock-ultimate.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-stats.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Enhanced Trackers
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/enhancedstats-addon.txt ]
then
  if diff $GOOGLEDIR/enhancedstats-addon.txt $MAINDIR/enhancedstats.txt >/dev/null ; then
    echo "No Changes detected: enhancedstats-addon.txt"
  else
    # echo "Updated: enhancedstats-addon.txt"
    # Clear old list
    rm -f $TESTDIR/enhancedstats.txt $TESTDIR/enhancedstats.txt.gz
    # Copy list from repo to RAMDISK
    cp -f $GOOGLEDIR/enhancedstats-addon.txt $TESTDIR/enhancedstats.txt
    # GZip
    $ZIP a -mx=9 -y -tgzip $TESTDIR/enhancedstats.txt.gz $TESTDIR/enhancedstats.txt > /dev/null
    # Clear Webhost-copy before copying and now Copy over GZip'd list
    cp -f $TESTDIR/enhancedstats.txt $MAINDIR/enhancedstats.txt
    rm -f $MAINDIR/enhancedstats.txt.gz
    cp -f $TESTDIR/enhancedstats.txt.gz $MAINDIR/enhancedstats.txt.gz
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-merged.sh
    # Combine (Main+Tracking+Enhanced) and Ultimate (Main+Tracking+Enhanced+Annoyances)
    $GOOGLEDIR/scripts/combine/firefox-adblock-ultimate.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror enhancedstats.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Addon/Annoyances
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/fanboy-adblocklist-addon.txt ]
then
  if diff $GOOGLEDIR/fanboy-adblocklist-addon.txt $MAINDIR/fanboy-addon.txt >/dev/null ; then
    echo "No Changes detected: fanboy-addon.txt"
  else
    # echo "Updated: fanboy-addon.txt"
    # Clear old list
    rm -f $TESTDIR/fanboy-addon.txt $TESTDIR/fanboy-addon.txt.gz
    # Copy list from repo to RAMDISK
    cp -f $GOOGLEDIR/fanboy-adblocklist-addon.txt $TESTDIR/fanboy-addon.txt
    # GZip
    $ZIP a -mx=9 -y -tgzip $TESTDIR/fanboy-addon.txt.gz $TESTDIR/fanboy-addon.txt > /dev/null
    # Clear Webhost-copy before copying and now Copy over GZip'd list
    cp -f $TESTDIR/fanboy-addon.txt $MAINDIR/fanboy-addon.txt
    rm -f $MAINDIR/fanboy-addon.txt.gz
    cp -f $TESTDIR/fanboy-addon.txt.gz $MAINDIR/fanboy-addon.txt.gz
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-merged.sh
    # Combine (Main+Tracking+Enhanced) and Ultimate (Main+Tracking+Enhanced+Annoyances)
    $GOOGLEDIR/scripts/combine/firefox-adblock-ultimate.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-addon.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# CZECH
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-cz.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-cz.txt $MAINDIR/fanboy-czech.txt >/dev/null ; then
    echo "No Changes detected: fanboy-czech.txt"
  else
   echo "Updated: fanboy-czech.txt"
   cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-cz.txt $MAINDIR/fanboy-czech.txt
   # Properly wipe old file.
   $SHRED -n 3 -z -u $MAINDIR/fanboy-czech.txt.gz
   $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-czech.txt.gz $MAINDIR/fanboy-czech.txt > /dev/null
   # Combine Regional trackers
   $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
   # Generate IE script
   $GOOGLEDIR/scripts/ie/czech-ie-generator.sh
   # Combine
   $GOOGLEDIR/scripts/combine/firefox-adblock-czech.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-cz.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# RUSSIAN
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-rus-v2.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-rus-v2.txt $MAINDIR/fanboy-russian.txt >/dev/null ; then
    echo "No Changes detected: fanboy-russian.txt"
  else
   echo "Updated: fanboy-russian.txt"
   cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-rus-v2.txt $MAINDIR/fanboy-russian.txt
   # Properly wipe old file.
   $SHRED -n 3 -z -u $MAINDIR/fanboy-russian.txt.gz
   $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-russian.txt.gz $MAINDIR/fanboy-russian.txt > /dev/null
   # Combine Regional trackers
   $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
   # Generate IE script
   $GOOGLEDIR/scripts/ie/russian-ie-generator.sh
   # Combine
   $GOOGLEDIR/scripts/combine/firefox-adblock-rus.sh
   # Generate Opera RUS script also
   $GOOGLEDIR/scripts/firefox/opera-russian.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-rus-v2.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# TURK
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-tky.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-tky.txt $MAINDIR/fanboy-turkish.txt >/dev/null ; then
    echo "No Changes detected: fanboy-turkish.txt"
  else
   echo "Updated: fanboy-turkish.txt"
   cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-tky.txt $MAINDIR/fanboy-turkish.txt
   # Properly wipe old file.
   $SHRED -n 3 -z -u  $MAINDIR/fanboy-turkish.txt.gz
   $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-turkish.txt.gz $MAINDIR/fanboy-turkish.txt > /dev/null
   # Combine Regional trackers
   $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
   # Generate IE script
   $GOOGLEDIR/scripts/ie/turkish-ie-generator.sh
   # Combine
   $GOOGLEDIR/scripts/combine/firefox-adblock-turk.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-tky.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# JAPANESE
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-jpn.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-jpn.txt $MAINDIR/fanboy-japanese.txt >/dev/null ; then
    echo "No Changes detected: fanboy-japanese.txt"
  else
   echo "Updated: fanboy-japanese.txt"
   cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-jpn.txt $MAINDIR/fanboy-japanese.txt
   # Properly wipe old file.
   $SHRED -n 3 -z -u  $MAINDIR/fanboy-japanese.txt.gz
   $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-japanese.txt.gz $MAINDIR/fanboy-japanese.txt > /dev/null
   # Combine Regional trackers
   $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
   # Generate IE script
   $GOOGLEDIR/scripts/ie/italian-ie-generator.sh
   # Combine
   $GOOGLEDIR/scripts/combine/firefox-adblock-jpn.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-jpn.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# KOREAN
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-krn.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-krn.txt $MAINDIR/fanboy-korean.txt > /dev/null ; then
    echo "No Changes detected: fanboy-korean.txt"
   else
    echo "Updated: fanboy-korean.txt"
    cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-krn.txt $MAINDIR/fanboy-korean.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/fanboy-korean.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-korean.txt.gz $MAINDIR/fanboy-korean.txt > /dev/null
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-krn.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-krn.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi


# ITALIAN
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-ita.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-ita.txt $MAINDIR/fanboy-italian.txt > /dev/null ; then
    echo "No Changes detected: fanboy-italian.txt"
   else
    echo "Updated: fanboy-italian.txt"
    cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-ita.txt $MAINDIR/fanboy-italian.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/fanboy-italian.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-italian.txt.gz $MAINDIR/fanboy-italian.txt > /dev/null
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Generate IE script
    $GOOGLEDIR/scripts/ie/italian-ie-generator.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-ita.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-ita.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# POLISH
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-pol.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-pol.txt $MAINDIR/fanboy-polish.txt > /dev/null ; then
    echo "No Changes detected: fanboy-polish.txt"
   else
    echo "Updated: fanboy-polish.txt"
    cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-pol.txt $MAINDIR/fanboy-polish.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/fanboy-polish.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-polish.txt.gz $MAINDIR/fanboy-polish.txt /dev/null
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-pol.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-pol.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# INDIAN
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-ind.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-ind.txt $MAINDIR/fanboy-indian.txt > /dev/null ; then
    echo "No Changes detected: fanboy-indian.txt"
   else
    echo "Updated: fanboy-indian.txt"
    cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-ind.txt $MAINDIR/fanboy-indian.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/fanboy-indian.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-indian.txt.gz $MAINDIR/fanboy-indian.txt > /dev/null
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-ind.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-ind.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# VIETNAM
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-vtn.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-vtn.txt $MAINDIR/fanboy-vietnam.txt > /dev/null ; then
    echo "No Changes detected: fanboy-vietnam.txt"
   else
    echo "Updated: fanboy-vietnam.txt"
    cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-vtn.txt $MAINDIR/fanboy-vietnam.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/fanboy-vietnam.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-vietnam.txt.gz $MAINDIR/fanboy-vietnam.txt > /dev/null
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-vtn.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-vtn.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# CHINESE
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-chn.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-chn.txt $MAINDIR/fanboy-chinese.txt > /dev/null ; then
    echo "No Changes detected: fanboy-chinese.txt"
   else
    echo "Updated: fanboy-chinese.txt"
    cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-chn.txt $MAINDIR/fanboy-chinese.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/fanboy-chinese.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-chinese.txt.gz $MAINDIR/fanboy-chinese.txt > /dev/null
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-chn.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-chn.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# ESPANOL
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-esp.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-esp.txt $MAINDIR/fanboy-espanol.txt > /dev/null ; then
    echo "No Changes detected: fanboy-espanol.txt"
   else
    echo "Updated: fanboy-espanol.txt"
    cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-esp.txt $MAINDIR/fanboy-espanol.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/fanboy-espanol.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-espanol.txt.gz $MAINDIR/fanboy-espanol.txt > /dev/null
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
		# Generate IE script
		$GOOGLEDIR/scripts/ie/espanol-ie-generator.sh
		# Combine
		$GOOGLEDIR/scripts/combine/firefox-adblock-esp.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-esp.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# SWEDISH
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/firefox-regional/fanboy-adblocklist-swe.txt ]
then
 if diff $GOOGLEDIR/firefox-regional/fanboy-adblocklist-swe.txt $MAINDIR/fanboy-swedish.txt > /dev/null ; then
    echo "No Changes detected: fanboy-swedish.txt"
   else
    echo "Updated: fanboy-swedish.txt"
    cp -f $GOOGLEDIR/firefox-regional/fanboy-adblocklist-swe.txt $MAINDIR/fanboy-swedish.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/fanboy-swedish.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/fanboy-swedish.txt.gz $MAINDIR/fanboy-swedish.txt > /dev/null
    # Combine Regional trackers
    $GOOGLEDIR/scripts/combine/firefox-adblock-intl-tracking.sh
    # Combine
    $GOOGLEDIR/scripts/combine/firefox-adblock-swe.sh
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror fanboy-adblocklist-swe.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Gannett
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/other/adblock-gannett.txt ]
then
 if diff $GOOGLEDIR/other/adblock-gannett.txt $MAINDIR/adblock-gannett.txt > /dev/null ; then
    echo "No Changes detected: fanboy-gannett.txt"
   else
    echo "Updated: fanboy-gannett.txt"
    cp -f $GOOGLEDIR/adblock-gannett.txt $MAINDIR/adblock-gannett.txt
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/adblock-gannett.txt.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/adblock-gannett.txt.gz $MAINDIR/adblock-gannett.txt > /dev/null
 fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror adblock-gannett.txt size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Create a combined script, to be used else where
if [ -n $TESTDIR/opera/urlfilter.ini ] || [ -n $TESTDIR/opera/urlfilter-stats.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $TESTDIR/opera/urlfilter-stats.ini > $TESTDIR/urlfilter-stats.ini
else
# echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter.ini/urlfilter-stats size is zero, please fix." mp3geek@gmail.com < /dev/null
fi
  

# Opera and Tracking filter.
if [ -n $TESTDIR/opera/urlfilter.ini ] || [ -n $TESTDIR/opera/urlfilter-stats.ini ]
then
  if diff $TESTDIR/opera/urlfilter.ini $MAINDIR/opera/urlfilter.ini > /dev/null ; then
    echo "No Changes detected: urlfilter.ini"
   else
    echo "Updated: urlfilter.ini"
    cp -f $TESTDIR/opera/urlfilter.ini $MAINDIR/opera/urlfilter.ini
    # Properly wipe old file.
    $SHRED -n 5 -z -u  $MAINDIR/opera/urlfilter.ini.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/urlfilter.ini.gz $TESTDIR/opera/urlfilter.ini > /dev/null
    # Generate Iron script
    # Turn off for the time being.
    $GOOGLEDIR/scripts/iron/adblock-iron-generator.sh
    # Combine tracking filter
    sed '/^$/d' $TESTDIR/urlfilter-stats.ini > $TESTDIR/urfilter-stats2.ini
    perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urfilter-stats2.ini
    if diff $TESTDIR/urfilter-stats2.ini $MAINDIR/opera/complete/urlfilter.ini > /dev/null ; then
      echo "No Changes detected: complete/urlfilter.ini"
    else
      echo "Updated: complete/urlfilter.ini"
      cp -f $TESTDIR/urfilter-stats2.ini $MAINDIR/opera/complete/urlfilter.ini
      # Properly wipe old file.
      $SHRED -n 5 -z -u  $MAINDIR/opera/complete/urlfilter.ini.gz
      $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/complete/urlfilter.ini.gz $TESTDIR/urfilter-stats2.ini > /dev/null
      # Generate Iron script
      # Turn off for the time being.
      $GOOGLEDIR/scripts/iron/adblock-iron-generator-tracker.sh  
    fi
  fi
else
# echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter.ini/urlfilter-stats size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Opera Czech
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/opera/urlfilter-cz.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-cz.ini > $TESTDIR/urlfilter-cz.ini
  sed '/^$/d' $TESTDIR/urlfilter-cz.ini > $TESTDIR/urlfilter-cz2.ini
  perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-cz2.ini
  if diff $TESTDIR/urlfilter-cz2.ini $MAINDIR/opera/cz/urlfilter.ini > /dev/null ; then
     echo "No Changes detected: czech/urlfilter.ini"
  else
     echo "Updated: czech/urlfilter.ini & czech/complete/urlfilter.ini"
     cat $TESTDIR/urlfilter-stats.ini $GOOGLEDIR/opera/urlfilter-cz.ini > $TESTDIR/urlfilter-cz-stats.ini
     perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-cz-stats.ini
     cp -f $TESTDIR/urlfilter-cz2.ini $MAINDIR/opera/cz/urlfilter.ini
     cp -f $TESTDIR/urlfilter-cz-stats.ini $MAINDIR/opera/cz/complete/urlfilter.ini
     # Properly wipe old file.
     $SHRED -n 3 -z -u  $MAINDIR/opera/cz/complete/urlfilter.ini.gz $MAINDIR/opera/cz/urlfilter.ini.gz
     $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/cz/complete/urlfilter.ini.gz $TESTDIR/urlfilter-cz-stats.ini > /dev/null
     $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/cz/urlfilter.ini.gz $TESTDIR/urlfilter-cz2.ini > /dev/null
     # Generate Iron script
     $GOOGLEDIR/scripts/iron/czech-iron-generator.sh  
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter-cz.ini size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Opera Polish
# Check for 0-sized file first
# 
if [ -n $GOOGLEDIR/opera/urlfilter-pol.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-pol.ini > $TESTDIR/urlfilter-pol.ini
  sed '/^$/d' $TESTDIR/urlfilter-pol.ini > $TESTDIR/urlfilter-pol2.ini
  perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-pol2.ini
  if diff $TESTDIR/urlfilter-pol2.ini $MAINDIR/opera/pol/urlfilter.ini > /dev/null ; then
      echo "No Changes detected: polish/urlfilter.ini"
  else
    echo "Updated: polish/urlfilter.ini & pol/complete/urlfilter.ini"
    cat $TESTDIR/urlfilter-stats.ini  $GOOGLEDIR/opera/urlfilter-pol.ini > $TESTDIR/urlfilter-pol-stats.ini
    perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-pol-stats.ini
    cp -f $TESTDIR/urlfilter-pol2.ini $MAINDIR/opera/pol/urlfilter.ini
    cp -f $TESTDIR/urlfilter-pol-stats.ini $MAINDIR/opera/pol/complete/urlfilter.ini
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/opera/pol/urlfilter.ini.gz $MAINDIR/opera/pol/complete/urlfilter.ini.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/pol/complete/urfilter.ini.gz $TESTDIR/urlfilter-pol-stats.ini > /dev/null
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/pol/urlfilter.ini.gz $TESTDIR/urlfilter-pol2.ini > /dev/null
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter-pol.ini size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Opera Espanol
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/opera/urlfilter-esp.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-esp.ini > $TESTDIR/urlfilter-esp.ini
  sed '/^$/d' $TESTDIR/urlfilter-esp.ini  > $TESTDIR/urlfilter-esp2.ini
  perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-esp2.ini
  if diff $TESTDIR/urlfilter-esp2.ini $MAINDIR/opera/esp/urlfilter.ini > /dev/null ; then
    echo "No Changes detected: esp/urlfilter.ini"
else
    echo "Updated: esp/urlfilter.ini & esp/complete/urlfilter.ini"
    cat $TESTDIR/urlfilter-stats.ini $GOOGLEDIR/opera/urlfilter-esp.ini > $TESTDIR/urlfilter-esp-stats.ini
    perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-esp-stats.ini
    cp -f $TESTDIR/urlfilter-esp-stats.ini $MAINDIR/opera/esp/complete/urlfilter.ini
    cp -f $TESTDIR/urlfilter-esp2.ini $MAINDIR/opera/esp/urlfilter.ini
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/opera/esp/urlfilter.ini.gz $MAINDIR/opera/esp/complete/urlfilter.ini.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/esp/urlfilter.ini.gz $TESTDIR/urlfilter-esp2.ini > /dev/null
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/esp/complete/urlfilter.ini.gz $TESTDIR/urlfilter-esp-stats.ini >/dev/null
    # Generate Iron script
    $GOOGLEDIR/scripts/iron/espanol-iron-generator.sh  
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter-esp.ini size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Opera Russian
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/opera/urlfilter-rus.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-rus.ini > $TESTDIR/urlfilter-rus.ini
  sed '/^$/d' $TESTDIR/urlfilter-rus.ini > $TESTDIR/urlfilter-rus2.ini
  perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-rus2.ini
  if diff $TESTDIR/urlfilter-rus2.ini $MAINDIR/opera/rus/urlfilter.ini > /dev/null ; then
    echo "No Changes detected: rus/urlfilter.ini"
  else
    echo "Updated: rus/urlfilter.ini & rus/complete/urlfilter.ini"
    cat $TESTDIR/urlfilter-stats.ini $GOOGLEDIR/opera/urlfilter-rus.ini > $TESTDIR/urlfilter-rus-stats.ini
    perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-rus-stats.ini
    cp -f $TESTDIR/urlfilter-rus-stats.ini $MAINDIR/opera/rus/complete/urlfilter.ini
    cp -f $TESTDIR/urlfilter-rus2.ini $MAINDIR/opera/rus/urlfilter.ini
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/opera/rus/complete/urlfilter.ini.gz $MAINDIR/opera/rus/urlfilter.ini.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/rus/complete/urlfilter.ini.gz $TESTDIR/urlfilter-rus-stats.ini >/dev/null
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/rus/urlfilter.ini.gz $TESTDIR/urlfilter-rus2.ini >/dev/null
    # Generate Iron script
    $GOOGLEDIR/scripts/iron/russian-iron-generator.sh  
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter-rus.ini size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Opera Swedish
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/opera/urlfilter-swe.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-swe.ini > $TESTDIR/urlfilter-swe.ini
  sed '/^$/d' $TESTDIR/urlfilter-swe.ini > $TESTDIR/urlfilter-swe2.ini
  perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-swe2.ini
  if diff $TESTDIR/urlfilter-swe2.ini $MAINDIR/opera/swe/urlfilter.ini > /dev/null ; then
    echo "No Changes detected: swe/urlfilter.ini"
  else
    echo "Updated: swe/urlfilter.ini & swe/complete/urlfilter.ini"
    cat $TESTDIR/urlfilter-stats.ini $GOOGLEDIR/opera/urlfilter-swe.ini > $TESTDIR/urlfilter-swe-stats.ini
    perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-swe-stats.ini
    cp -f $TESTDIR/urlfilter-swe-stats.ini $MAINDIR/opera/swe/complete/urlfilter.ini
    cp -f $TESTDIR/urlfilter-swe2.ini $MAINDIR/opera/swe/urlfilter.ini
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/opera/swe/urlfilter.ini.gz $MAINDIR/opera/swe/complete/urlfilter.ini.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/swe/complete/urlfilter.ini.gz $TESTDIR/urlfilter-swe-stats.ini > /dev/null
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/swe/urlfilter.ini.gz $TESTDIR/urlfilter-swe2.ini > /dev/null
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter-swe.ini size is zero, please fix." mp3geek@gmail.com < /dev/null
fi
    
# Opera JPN
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/opera/urlfilter-jpn.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-jpn.ini > $TESTDIR/urlfilter-jpn.ini
  sed '/^$/d' $TESTDIR/urlfilter-jpn.ini > $TESTDIR/urlfilter-jpn2.ini
  perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-jpn2.ini
  if diff $TESTDIR/urlfilter-jpn2.ini $MAINDIR/opera/jpn/urlfilter.ini > /dev/null ; then
    echo "No Changes detected: jpn/urlfilter.ini"
  else
    echo "Updated: jpn/urlfilter.ini & jpn/complete/urlfilter.ini"
    cat $TESTDIR/urlfilter-stats.ini $GOOGLEDIR/opera/urlfilter-jpn.ini > $TESTDIR/urlfilter-jpn-stats.ini
    perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-jpn-stats.ini
    cp -f $TESTDIR/urlfilter-jpn-stats.ini $MAINDIR/opera/jpn/complete/urlfilter.ini
    cp -f $TESTDIR/urlfilter-jpn2.ini $MAINDIR/opera/jpn/urlfilter.ini
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/opera/jpn/urlfilter.ini.gz $MAINDIR/opera/jpn/complete/urlfilter.ini.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/jpn/complete/urlfilter.ini.gz $TESTDIR/urlfilter-jpn-stats.ini > /dev/null
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/jpn/urlfilter.ini.gz $TESTDIR/urlfilter-jpn2.ini > /dev/null
    # Generate Iron script
    $GOOGLEDIR/scripts/iron/japanese-iron-generator.sh  
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter-jpn.ini size is zero, please fix." mp3geek@gmail.com < /dev/null
fi
    
# Opera VTN
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/opera/urlfilter-vtn.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-vtn.ini > $TESTDIR/urlfilter-vtn.ini
  sed '/^$/d' $TESTDIR/urlfilter-vtn.ini > $TESTDIR/urlfilter-vtn2.ini
  perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-vtn2.ini
  if diff $TESTDIR/urlfilter-vtn2.ini $MAINDIR/opera/vtn/urlfilter.ini > /dev/null ; then
    echo "No Changes detected: vtn/urlfilter.ini"
  else
    echo "Updated: vtn/urlfilter.ini & vtn/complete/urlfilter.ini"
    cat $TESTDIR/urlfilter-stats.ini $GOOGLEDIR/opera/urlfilter-vtn.ini > $TESTDIR/urlfilter-vtn-stats.ini
    perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-vtn-stats.ini
    cp -f $TESTDIR/urlfilter-vtn-stats.ini $MAINDIR/opera/vtn/complete/urlfilter.ini
    cp -f $TESTDIR/urlfilter-vtn2.ini $MAINDIR/opera/vtn/urlfilter.ini
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/opera/vtn/urlfilter.ini.gz $MAINDIR/opera/vtn/complete/urlfilter.ini.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/vtn/complete/urlfilter.ini.gz $TESTDIR/urlfilter-vtn-stats.ini > /dev/null
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/vtn/urlfilter.ini.gz $TESTDIR/urlfilter-vtn2.ini > /dev/null
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter-vtn.ini size is zero, please fix." mp3geek@gmail.com < /dev/null
fi

# Opera Turk
# Check for 0-sized file first
#
if [ -n $GOOGLEDIR/opera/urlfilter-tky.ini ]
then
  cat $TESTDIR/opera/urlfilter.ini $GOOGLEDIR/opera/urlfilter-tky.ini > $TESTDIR/urlfilter-tky.ini
  sed '/^$/d' $TESTDIR/urlfilter-tky.ini >  $TESTDIR/urlfilter-tky2.ini
  perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-tky2.ini
  if diff $TESTDIR/urlfilter-tky2.ini $MAINDIR/opera/trky/urlfilter.ini > /dev/null ; then
    echo "No Changes detected: trky/urlfilter.ini"
  else
    echo "Updated: trky/urlfilter.ini & trky/complete/urlfilter.ini"
    cat $TESTDIR/urlfilter-stats.ini $GOOGLEDIR/opera/urlfilter-tky.ini > $TESTDIR/urlfilter-tky-stats.ini
    perl $TESTDIR/addChecksum-opera.pl $TESTDIR/urlfilter-tky-stats.ini
    cp -f $TESTDIR/urlfilter-tky-stats.ini $MAINDIR/opera/trky/complete/urlfilter.ini
    cp -f $TESTDIR/urlfilter-tky2.ini $MAINDIR/opera/trky/urlfilter.ini
    # Properly wipe old file.
    $SHRED -n 3 -z -u  $MAINDIR/opera/trky/complete/urlfilter.ini.gz $MAINDIR/opera/trky/urlfilter.ini.gz
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/trky/complete/urlfilter.ini.gz $TESTDIR/urlfilter-tky-stats.ini > /dev/null
    $ZIP a -mx=9 -y -tgzip $MAINDIR/opera/trky/urlfilter.ini.gz $TESTDIR/urlfilter-tky2.ini > /dev/null
  fi
else
  # echo "Something went bad, file size is 0"
  mail -s "Google mirror urlfilter-tky.ini size is zero, please fix." mp3geek@gmail.com < /dev/null
fi
