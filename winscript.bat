@echo off
hg update
hg pull --rebase remote
hg pull
:: Kill any lines less than 3chars automatically
perl -i.bak -n -e "{print if /.{4}/}" fanboy-adblocklist-current-expanded.txt
perl -i.bak -n -e "{print if /.{4}/}" fanboy-adblocklist-stats.txt
perl -i.bak -n -e "{print if /.{4}/}" fanboy-adblocklist-addon.txt
:: Firefox
perl addChecksum.pl fanboy-adblocklist-adult.txt
perl addChecksum.pl fanboy-adblocklist-current-expanded.txt
perl addChecksum.pl fanboy-adblocklist-stats.txt  
perl addChecksum.pl fanboy-adblocklist-dimensions-v2.txt
perl addChecksum.pl fanboy-adblocklist-current-p2p.txt
perl addChecksum.pl fanboy-adblocklist-stats-intl.txt
perl addChecksum.pl fanboy-adblocklist-addon.txt
perl addChecksum.pl adblock-gannett.txt
perl addChecksum.pl other\chrome-addon.txt
:: Firefox Regional lists
perl addChecksum.pl firefox-regional\fanboy-adblocklist-chn.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-cz.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-esp.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-ita.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-jpn.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-krn.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-rus-v2.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-swe.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-tky.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-vtn.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-ind.txt
perl addChecksum.pl firefox-regional\fanboy-adblocklist-pol.txt
:: Opera
perl addChecksum.pl opera\fanboy-adblocklist-elements-v3.css
perl addChecksum-opera.pl opera\urlfilter.ini
:: Iron
perl addChecksum-opera.pl iron/adblock-beta.ini
:: Remove Bak files before commiting.
del /f *.bak
:: Now sync
hg add .
hg commit -m "%*"
hg push
