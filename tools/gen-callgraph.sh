#!/bin/bash

# gen-callgraph
# -- A script to generate call graph from elf binary
# Copyright (C) 2011 onlyuser <mailto:onlyuser@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

CMD=`basename $0`

show_help()
{
    echo "Usage: $CMD <BINARY> [DEBUG={0*/1}] | dot -Tpng -ocallgraph.png"
}

if [ $# -ne 1 -a $# -ne 2 ]; then
    echo "Fail! -- Expecting 1 or 2 arguments! ==> $@"
    show_help
    exit 1
fi

if [ -z "`which readelf`" ]; then
    echo "Error: Requires \"readelf\""
    exit 1
fi

if [ -z "`which objdump`" ]; then
    echo "Error: Requires \"objdump\""
    exit 1
fi

if [ -z "`which c++filt`" ]; then
    echo "Error: Requires \"c++filt\""
    exit 1
fi

if [ -z "`which dot`" ]; then
    echo "Error: Requires \"dot\""
    exit 1
fi

EXEC=$1
DEBUG=$2

if [ ! -f "$EXEC" ]; then
    echo "Error: $EXEC doesn't exist!"
    exit 1
fi

if [ -z "$DEBUG" ]; then
    DEBUG=0
fi

trap "unset FUNC_PAIR_ARRAY ASM_CMD_HASHMAP UNIQ_FUNC" EXIT

#readelf $EXEC --all
GEN_SYM_FILE_CMD="readelf $EXEC --headers --symbols"

#http://stackoverflow.com/questions/1737095/how-do-i-disassemble-raw-x86-code
#http://stackoverflow.com/questions/19071461/disassemble-raw-x64-machine-code

#objdump -D -b binary -mi386 -Maddr16,data16 $EXEC
GEN_ASM_FILE_CMD="objdump -D -b binary -marm $EXEC"

if [ "$DEBUG" == 1 ]; then
    echo "readelf command: $GEN_SYM_FILE_CMD" 1>&2
    echo "objdump command: $GEN_ASM_FILE_CMD" 1>&2
    echo "" 1>&2
fi

SYM_FILE_CONTENTS="`$GEN_SYM_FILE_CMD`"
ASM_FILE_CONTENTS="`$GEN_ASM_FILE_CMD`"

if [ "$DEBUG" == 1 ]; then
    DEBUG_SYM_FILE="`mktemp`"
    DEBUG_ASM_FILE="`mktemp`"
    #trap "rm $DEBUG_SYM_FILE $DEBUG_ASM_FILE" EXIT
    echo "$SYM_FILE_CONTENTS" > $DEBUG_SYM_FILE
    echo "$ASM_FILE_CONTENTS" > $DEBUG_ASM_FILE
    echo "Cached readelf output: $DEBUG_SYM_FILE" 1>&2
    echo "Cached objdump output: $DEBUG_ASM_FILE" 1>&2
    echo "" 1>&2
fi

ENTRY_POINT_LINE="`echo \"$SYM_FILE_CONTENTS\" | grep \"Entry point address:\"`"
ENTRY_POINT_ADDR="`echo \"$ENTRY_POINT_LINE\" | cut -d':' -f2 | tr -d ' ' | sed 's/^0x4[0]*//g'`"

declare -a FUNC_PAIR_ARRAY

echo "Analyzing symbol table.. (Step 1 of 4)" 1>&2
FOUND_SYMTAB=0
n="`echo \"$SYM_FILE_CONTENTS\" | wc -l`"
i=0
FUNC_COUNT=0
while read SYM_FILE_LINE; do
    PROGRESS=$(( $i * 100 / $n ))
    printf "\r$PROGRESS%%" 1>&2

    if [ "$FOUND_SYMTAB" == 0 ]; then
        if [[ "$SYM_FILE_LINE" =~ "Symbol table '.symtab'" ]]; then
            FOUND_SYMTAB=1
        else
            continue
        fi
    fi
    SYM_TUPLE="`echo \"$SYM_FILE_LINE\" | sed 's/[ ]\+/ /g'`"
    if [ "`echo \"$SYM_TUPLE\" | cut -d' ' -f4`" == "FUNC" ] &&
       [ "`echo \"$SYM_TUPLE\" | cut -d' ' -f5`" != "LOCAL" ] &&
       [ "`echo \"$SYM_TUPLE\" | cut -d' ' -f7`" != "UND" ];
    then
        FUNC_PAIR="`echo \"$SYM_TUPLE\" | cut -d' ' -f2,8 | sed 's/^00000000004[0]*//g'`"
        FUNC_ADDR="`echo \"$FUNC_PAIR\" | cut -d' ' -f1`"
        FUNC_ADDR="`printf \"%08x\" 0x$FUNC_ADDR`"
        FUNC_NAME="`echo \"$FUNC_PAIR\" | cut -d' ' -f2`"
        FUNC_PAIR_ARRAY[$FUNC_COUNT]="$FUNC_ADDR $FUNC_NAME"
        FUNC_COUNT=$(( $FUNC_COUNT + 1 ))
    fi

    i=$(( $i + 1 ))
done <<< "$SYM_FILE_CONTENTS"
echo -e "\r100%" 1>&2
if [ "$FOUND_SYMTAB" == 0 ]; then
    echo "Error: Can't find symtab section in \"$EXEC\"."
    exit
fi
IFS=$'\n'; SORTED_FUNC_PAIR_ARRAY=($(sort <<< "${FUNC_PAIR_ARRAY[*]}")); unset IFS
SORTED_FUNC_PAIR_LIST="`printf \"%s\n\" \"${SORTED_FUNC_PAIR_ARRAY[@]}\"`"

if [ "$DEBUG" == 1 ]; then
    DEBUG_FUNC_PAIR_FILE="`mktemp`"
    echo "$SORTED_FUNC_PAIR_LIST" > $DEBUG_FUNC_PAIR_FILE
    echo "Generated function address pairs: $DEBUG_FUNC_PAIR_FILE" 1>&2
    echo "" 1>&2
fi

declare -A ASM_CMD_HASHMAP

TAB=`printf '\t'`

echo "Analyzing disassembly.. (Step 2 of 4)" 1>&2
n="`echo \"$ASM_FILE_CONTENTS\" | wc -l`"
i=0
while read ASM_FILE_LINE; do
    PROGRESS=$(( $i * 100 / $n ))
    printf "\r$PROGRESS%%" 1>&2

    REGEX="^[ ]*([a-h0-9]*):$TAB(.*)$TAB(.*)"
    if ! [[ "$ASM_FILE_LINE" =~ $REGEX ]]; then
        i=$(( $i + 1 ))
        continue
    fi

    ASM_FILE_LINE_ADDR="${BASH_REMATCH[1]}"
    ASM_FILE_LINE_CMD="${BASH_REMATCH[3]}"
    ASM_CMD_HASHMAP[$ASM_FILE_LINE_ADDR]="$i:$ASM_FILE_LINE_CMD"

    i=$(( $i + 1 ))
done <<< "$ASM_FILE_CONTENTS"
echo -e "\r100%" 1>&2

echo "digraph `basename $EXEC | sed 's/\./_/g'` {"
echo "rankdir=LR;"
echo "node [shape=ellipse];"

declare -A UNIQ_FUNC

echo "Generating nodes.. (Step 3 of 4)" 1>&2
for i in `seq 0 $(( $FUNC_COUNT - 1 ))`; do
    PROGRESS=$(( $i * 100 / $FUNC_COUNT ))
    printf "\r$PROGRESS%%" 1>&2
    FUNC_PAIR=${SORTED_FUNC_PAIR_ARRAY[$i]}

    FUNC_ADDR="`echo \"$FUNC_PAIR\" | cut -d' ' -f1`"
    FUNC_ADDR="`printf \"%x\" 0x$FUNC_ADDR`"

    if [ -n "${UNIQ_FUNC[$FUNC_ADDR]}" ]; then
        continue
    fi
    UNIQ_FUNC[$FUNC_ADDR]="1"

    FUNC_NAME="`echo \"$FUNC_PAIR\" | cut -d' ' -f2`"
    FUNC_NAME_DEMANGLED="`echo $FUNC_NAME | c++filt`"
    if [ "$FUNC_ADDR" == "$ENTRY_POINT_ADDR" ]; then
        SHAPE_SPEC_STR=", shape=\"box\""
    else
        SHAPE_SPEC_STR=""
    fi

    echo "$FUNC_NAME [label=\"0x$FUNC_ADDR: $FUNC_NAME_DEMANGLED\"$SHAPE_SPEC_STR];"
done
echo -e "\r100%" 1>&2

echo "Generating edges.. (Step 4 of 4)" 1>&2
for i in `seq 0 $(( $FUNC_COUNT - 1 ))`; do
    PROGRESS=$(( $i * 100 / $FUNC_COUNT ))
    printf "\r$PROGRESS%%" 1>&2
    FUNC_PAIR=${SORTED_FUNC_PAIR_ARRAY[$i]}

    FUNC_ADDR="`echo \"$FUNC_PAIR\" | cut -d' ' -f1`"
    FUNC_ADDR="`printf \"%x\" 0x$FUNC_ADDR`"
    FUNC_NAME="`echo \"$FUNC_PAIR\" | cut -d' ' -f2`"
    FUNC_ASM_LINE_NO="`echo ${ASM_CMD_HASHMAP[$FUNC_ADDR]} | cut -d':' -f1`"
    if [ -z "$FUNC_ASM_LINE_NO" ]; then
        i=$(( $i + 1 ))
        continue
    fi

    NEXT_FUNC_INDEX=$(( $i + 1 ))
    NEXT_FUNC_PAIR=${SORTED_FUNC_PAIR_ARRAY[$NEXT_FUNC_INDEX]}
    if [ -z "$NEXT_FUNC_PAIR" ]; then
        i=$(( $i + 1 ))
        continue
    fi

    NEXT_FUNC_ADDR="`echo \"$NEXT_FUNC_PAIR\" | cut -d' ' -f1`"
    NEXT_FUNC_ADDR="`printf \"%x\" 0x$NEXT_FUNC_ADDR`"
    NEXT_FUNC_NAME="`echo \"$NEXT_FUNC_PAIR\" | cut -d' ' -f2`"
    NEXT_FUNC_ASM_LINE_NO="`echo ${ASM_CMD_HASHMAP[$NEXT_FUNC_ADDR]} | cut -d':' -f1`"
    if [ -z "$NEXT_FUNC_ASM_LINE_NO" ]; then
        i=$(( $i + 1 ))
        continue
    fi

    FUNC_ASM_LAST_LINE_NO=$(( $NEXT_FUNC_ASM_LINE_NO - 1 ))
    FUNC_ASM_BODY_LEN=$(( $NEXT_FUNC_ASM_LINE_NO - $FUNC_ASM_LINE_NO ))
    FUNC_ASM_BODY="`echo \"$ASM_FILE_CONTENTS\" | head -$FUNC_ASM_LAST_LINE_NO | tail -$FUNC_ASM_BODY_LEN`"
    CALLEE_ASM_LINES_LIST="`echo \"$FUNC_ASM_BODY\" | egrep '\<callq\>|\<jmpq\>|\<jmp\>|\<je\>|\<jne\>|\<jg\>|\<jge\>|\<jl\>|\<jle\>'`"
    if [ -z "$CALLEE_ASM_LINES_LIST" ]; then
        i=$(( $i + 1 ))
        continue
    fi

    while read -r CALLEE_ASM_LINE; do
        CALLEE_ADDR_PART="`echo \"$CALLEE_ASM_LINE\" | cut -d$'\t' -f1`"
        CALL_ADDR="`echo \"$CALLEE_ADDR_PART\" | cut -d':' -f1`"
        CALLEE_CMD="`echo \"$CALLEE_ASM_LINE\" | cut -d$'\t' -f3`"
        CALLEE_ADDR="`echo \"$CALLEE_CMD\" | sed 's/callq[ ]\+0x\([^ ]\+\)/\1/g' | sed 's/j[^ ]\+[ ]\+0x\([^ ]\+\)/\1/g'`"
        CALLEE_NAME="`echo \"$SORTED_FUNC_PAIR_LIST\" | grep \"^[0]*$CALLEE_ADDR\" | head -1 | cut -d' ' -f2`"
        if [ -z "$CALLEE_NAME" ]; then
            continue
        fi
        echo "$FUNC_NAME -> $CALLEE_NAME [label=\"0x$CALL_ADDR\"]"
    done <<< "$CALLEE_ASM_LINES_LIST"
done
echo -e "\r100%" 1>&2

echo "}"

echo "Done!" 1>&2