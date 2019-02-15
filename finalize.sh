#!/bin/bash
echo ":::: OS's Homework's Files Generator 1.1 - GOLD Edition ::::"

EXE_PATH="`( cd \"$(dirname \"$0\")\" && pwd )`"
PANDOC_OPTS="-V geometry:margin=2cm -f commonmark -H $EXE_PATH/h.tex"

question() {
	echo $1
	echo " [Y, n]"
	read tmp
	if [ -z "$tmp" -o "$tmp" = "y" -o "$tmp" = "y" ]; then
		return 0
	else
		return 1
	fi
}

set -e

echo WARNING: considering the current directory as the exercise\'s directory
echo " (`pwd`)"

if [ `find . -name "*report.md" |wc -l` -gt 0 ]; then
	echo it seems you wrote the reports in MarkDown!
	if question "do you want to convert them automaticaly in PDF?"; then
		for d in `ls`; do
			n=`echo $d|cut -c 2-`
			echo elaborating \"$d\" ...
			cd $d
			pandoc $PANDOC_OPTS E${n}_report.md -o E${n}_report.pdf
			pandoc $PANDOC_OPTS E${n}_text.md -o E${n}_text.pdf
			cd ..
		done
	fi
fi
zipname=$(basename $(pwd))

echo creating copy of $zipname to work on ...
cp -r . ../"$zipname"~
cd ../"$zipname"~
echo removing unneeded files ...
# files used to generate reports and exercises text
find . -type f "(" -name "*.odt" -o -name "*.md" -o -name "*.jpg" -o -name "*.png" ")" -delete 
# binary files (compiled C usually)
find . -type f -executable -exec sh -c "file -i '{}' | grep -q '-executable; charset=binary'" \; -print | xargs rm -f

echo creating archive ${zipname}.tar.gz ...
tar -czf "${zipname}.tar.gz" *
mv ${zipname}.tar.gz ../
cd ..
rm -r "$zipname"~

echo
echo final result of ${zipname}.tar.gz :
tar -tzf "${zipname}.tar.gz"
