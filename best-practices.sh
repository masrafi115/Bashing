#!/bin/bash


RED="\033[0;31m"
LRED="\033[1;31m"
GREEN="\033[0;32m"
LGREEN="\033[1;32m"
YELLOW="\033[0;33m"
LYELLOW="\033[1;33m"
BLUE="\033[0;34m"
LBLUE="\033[1;34m"
LWHITE="\033[1;37m"
NONE="\033[0m"

VERSION="${LBLUE}\
qpack - 2022.5.30${NONE}
"

script_name=${0##*/}

usage="${YELLOW}\
Usage: $script_name <binary file> [options] [args]...
Options:
  -o <output dir>
	  Specify the package dir.
	  The default dir is \"__XXX_pack\".
  -t
	  tar the package automatically.
  -v
	  Print the version(the last time modified the script).
  --help
	  Print the help info.${NONE}
"

if [ $# -lt 1 ];
then
	printf "$usage"
	exit 1
fi

#Option -v: print version and exit.
if [ $1 == "-v" ];
then
	printf "$VERSION"
	exit 0
fi
#Option --help:
if [ $1 == "--help" ]
then
	printf "$usage"
	exit 0
fi

project_dir=$(dirname $1)
cd $project_dir

out_dir=""
binary=$(basename $1)
if [ ! -e $binary ];then
	printf "${LRED}Binary file does not exist!\n"
	exit 1
fi
shift

FLAG_TAR=""
while getopts "o:t" option;
do
	case "$option"
	in
		o) out_dir=${OPTARG};;
		t) FLAG_TAR="true";;
		?) printf "$usage"
			exit 1;;
	esac
done



#STAGE 1
printf "${LWHITE}Stage 1: Pack executable binary file.\n"
tardir=$(echo __$binary"_pack" | awk '{print tolower($0)}')
if [ "$out_dir" != "" ];then
	tardir=$out_dir
fi
rm -rf $tardir
mkdir $tardir
printf "${LBLUE}Created tardir:$tardir.\n"

#copy the executable binary file.
chmod u+x $binary
cp $binary $tardir
printf "${YELLOW}Copied $binary ${NONE}to${BLUE} $tardir.\n"

#STAGE 2
printf "${LWHITE}Stage 2: Pack project files.\n"
#step2: copy other files and dirs.
for files_dirs in $(ls ./)
do
	if [ "$files_dirs" != "$script_name" ] && [ "$files_dirs" != "$binary" ] && [ "$files_dirs" != "$tardir" ]; then
		cp -r $files_dirs $tardir
		printf "${YELLOW}Copied $files_dirs ${NONE}to${BLUE} $tardir.\n"
	fi
done


#STAGE 3
printf "${LWHITE}Stage 3: Pack Qt library.\n"
#create the lib directory.
libdir=$PWD/$tardir/lib
rm -rf $libdir
mkdir $libdir
printf "${LBLUE}Created $libdir.\n"

#copy all dependencies across to the tar directory.
for dep in $(ldd ./$binary | awk '{if (match($3, "/")) {printf $3" "}}')
do
	cp $dep $libdir
	printf "${YELLOW}Copied $dep ${NONE}to${BLUE} $libdir.\n"
done


#STAGE 4
printf "${LWHITE}Stage 4: Pack Qt platform plugin and library.\n"
#please change this to wherever libqxcb.so lives on your pc.
qt_platform_plugin=/home/QT_install/6.3.0/gcc_64/plugins/platforms/libqxcb.so
qt_platform_plugin_dir=$tardir/platforms

mkdir $qt_platform_plugin_dir
cp $qt_platform_plugin $qt_platform_plugin_dir
printf "${YELLOW}Copied $qt_platform_plugin ${NONE}to${BLUE} $qt_platform_plugin_dir.\n"

for dep in $(ldd $qt_platform_plugin | awk '{if(match($3, "/")) {printf $3" "}}')
do
	cp $dep $libdir
	printf "${YELLOW}Copied $dep ${NONE}to${BLUE} $libdir.\n"
done

#STAGE 5
printf "${LWHITE}Stage 5: Created executable script.\n"
#create the run script.
exec_script=$tardir/"run_$binary.sh"

echo '#!/bin/bash
export LD_LIBRARY_PATH=$(pwd)/lib
script_path=$(dirname $0)
./${script_path}/'"$binary" > $exec_script

chmod u+x $exec_script
printf "${LBLUE}Created executable script.\n"
printf "${LYELLOW}Done.\n"

cd - >> /dev/null

#move $tardir to the project dir if not existing
if [ ! -e $tardir ]
then
	rm -rf $tardir
	mv $project_dir/$tardir ./ >> /dev/null
fi
#Option -t
if [ "$FLAG_TAR" == "true" ];
then
	printf "${LBLUE}Option -t: packing with tar...\n"
	printf "${YELLOW}"
	rm -rf ${tardir}.tar
	tar -zcvf ./${tardir}.tar ./$tardir
	rm -rf $tardir
fi

printf "${NONE}"