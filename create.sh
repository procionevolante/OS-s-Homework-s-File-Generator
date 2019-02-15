#!/bin/bash
echo ":::: OS's Homework's Files Generator 1.1 - GOLD Edition ::::"


# checks if the argument passed is an unsigned number
check_num () {
	printf '%d' "$1" > /dev/null 2>&1
	return $?
}

# reads a variable using readline & returns it
# input [prompt] [var_name]
input () {
	#echo -n "$1"
	echo "$1"
	read -ep "> " $2
}

# prints the value set in the configuration file for $1
cfg_val() {
	grep -E ^"$1"= config | cut -d '=' -f 2-
}

set -e
EXE_PATH="`( cd \"$(dirname \"$0\")\" && pwd )`"

cd "$EXE_PATH"

if ! [ -e ".firstTime" ]; then
	cat <<- EOF
		-------------------------------------------------------------------
		it seems that this is the first time you execute this program.
		Therefore, please insert the correct data (student ID, name) in the
		configuration file (config)
		
		For a very slightly more descriptive guide on how to use this thing
		read the README
		-------------------------------------------------------------------
	EOF
	echo > ".firstTime"
fi

echo -n reading config file ...
if [ -f config ]; then
	ID=$(cfg_val STUDENT_ID)
	NAME=$(cfg_val NAME)
	SURNAME=$(cfg_val SURNAME)
	report_ftype=$(cfg_val REPORT_FILETYPE)
	echo DONE!
else
	echo ERROR!
	exit 1
fi

cd - > /dev/null

input 'insert laboratory number (1,2,3,..): ' nlab
if ! check_num $nlab; then
	echo \"$nlab\" is not a valid number
	exit 1
fi
nlab=`printf '%02d' $nlab`

input 'insert number of exercises (1,2,3,..): ' nex
if ! check_num $nex; then
	echo \"$nex\" is not a valid number
	exit 1
fi
zip_name=S${ID}_L${nlab}_${NAME}${SURNAME}
echo zip name is \"$zip_name\"

echo available exercise\'s types:
# note that this only works with types that contain only one "." in the path
ls "$EXE_PATH/templates/" | grep -E '(.+)\.\1' | cut -d . -f 1
input "choose type of exercise: " type
if ! [ -f "$EXE_PATH/templates/$type.$type" ]; then
	echo "type $type not found (does file $EXE_PATH/templates/$type.$type exists?)"
	exit 2
fi

echo creating structure on disk ...
mkdir $zip_name
cd $zip_name
for i in `seq -f '%02.0f' 1 $nex`; do
	mkdir D$i
	cp -v  "$EXE_PATH/templates/report.$report_ftype" "D$i/E${i}_report.$report_ftype"
	cp -v  "$EXE_PATH/templates/text.$report_ftype" "D$i/E${i}_text.$report_ftype"
	# -r so also custom directories templates are supported
	cp -rv "$EXE_PATH/templates/$type.$type" "D$i/E${i}.$type"
	cd D$i
	sed -i "s/%LAB_NUM%/${nlab}/g" *
	sed -i "s/%EXERCISE_NUM%/${i}/g" *
	sed -i "s/%STUDENT_ID%/${ID}/g" *
	sed -i "s/%SURNAME%/${SURNAME}/g" *
	sed -i "s/%NAME%/${NAME}/g" *
	cd ..
done
