#!/bin/sh
SKIPUNZIP=1


ui_print "*******************************"
ui_print "     Magisk Phenomena Font     "
ui_print "*******************************"

ui_print "- Extracting module files"
unzip -o "$ZIPFILE" -x 'META-INF/*' fonts.tar.xz -d $MODPATH >&2
# --------------------------------------------
ui_print "- Searching in fonts.xml"
[[ -d /sbin/.magisk/mirror ]] && MIRRORPATH=/sbin/.magisk/mirror || unset MIRRORPATH
FILEPATH=/system/etc
FILE=fonts.xml
mkdir -p $MODPATH/$FILEPATH 2>/dev/null

ui_print "- Unzipping font files..."
FONTSPATH=/system/fonts
unzip -oj "$ZIPFILE" fonts.tar.xz -d $TMPDIR >&2
mkdir -p $MODPATH/$FONTSPATH 2>/dev/null
tar -xf $TMPDIR/fonts.tar.xz -C $MODPATH/$FONTSPATH 2>/dev/null


ui_print "- Installing fonts..."
RAWFONTS=$(sed -En '/<family name="sans-serif-condensed">/,/<\/family>/ {s|.*<font weight="400" style="normal">(.*).ttf<\/font>.*|\1|p}' $MIRRORPATH/$FILEPATH/$FILE|cut -f1 -d-)
NEWFONTS='PhenomenaCondensed'

# Just replace
for _font in `ls -1 $MODPATH/$FONTSPATH/*.ttf | sed -Ene 's|.*/([^/]+)|\1|' -e "s|${NEWFONTS}-||p"`; do
  ln -s $FONTSPATH/${NEWFONTS}-$_font $MODPATH/$FONTSPATH/${RAWFONTS}-$_font
done

# Default permissions
set_perm_recursive $MODPATH 0 0 0755 0644
