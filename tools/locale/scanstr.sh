#!/bin/bash

#
# scanstr.sh - Scan for Resource String
#
# This source-code is part of Windows XP stuff for XFCE:
# <<https://www.oddmatics.uk>>
#
# Author(s): Rory Fewell <roryf@oddmatics.uk>
#

#
# CONSTANTS
#
CURDIR=`realpath -s "./"`
FILE_PRIORITY=(
    'explorer.exe'
    'shell32.dll'
    'comdlg32.dll'
)
REQUIRED_PACKAGES=(
    'p7zip'
    'ripgrep'
)
SCRIPTDIR=`dirname "$0"`

LOG_PATH="${CURDIR}/scanerr.log"
MUIS_DIR="${SCRIPTDIR}/mui-stuff"
SH_MUI2ISO="${SCRIPTDIR}/mui2iso.sh"
TMP_7Z_DIR="${CURDIR}/tmp.extract"

SOURCE_XP_DIR="${MUIS_DIR}/xp"
TMP_STRING_FILE="${TMP_7Z_DIR}/.rsrc/string.txt"



#
# PRE-FLIGHT CHECKS
#
for package in "${REQUIRED_PACKAGES[@]}"
do
    dpkg -s $package > /dev/null 2>&1

    if [[ $? -gt 0 ]]
    then
        echo "You are missing package: ${package}"
        exit 1
    fi
done



#
# ARGUMENTS
#
if [[ $# -eq 0 ]] || [[ "${1}" == "--help" ]]
then
    echo 'scanstr.sh - Scan for Resource String'
    echo ''
    echo 'This script scans the Windows XP files to try and find a string, and get its'
    echo 'ID from resources.'
    echo ''
    echo 'Usage:'
    echo '    scanstr.sh <string>'
    echo ''
    echo 'Example:'
    echo '    scanstr.sh "Cancel"'
    echo ''
    exit 0
fi

if [[ $# -gt 1 ]]
then
    echo 'Too many arguments!'
    echo 'Usage: scanstr.sh <string> OR scanstr.sh for detailed usage.'
    exit 1
fi



#
# FUNCTIONS
#

# cache_strings
#
# Retrieves the string table for a file and caches it for reading
#
cache_strings()
{
    local file_path="${1}"
    local cache_path="${file_path}.strings"

    if [[ -f "${cache_path}" ]]
    then
        return 0
    fi

    if [[ -d "${TMP_7Z_DIR}" ]]
    then
        rm -rf "${TMP_7Z_DIR}" >/dev/null 2>>"${LOG_PATH}"
    fi

    # Use 7zip to extract the file - should contain .rsrc/strings.txt if there is a
    # string table within
    #
    7z x "${file_path}" -o"${TMP_7Z_DIR}" >/dev/null 2>>"${LOG_PATH}"

    if [[ $? -gt 0 ]]
    then
        return 1
    fi

    if [[ -f "${TMP_STRING_FILE}" ]]
    then
        # Cache the strings file now
        #
        mv "${TMP_STRING_FILE}" "${cache_path}" >/dev/null 2>>"${LOG_PATH}"
    else
        # Create a dummy file so we don't waste time on this file in future
        #
        touch "${cache_path}" >/dev/null 2>>"${LOG_PATH}"
    fi

    if [[ $? -gt 0 ]]
    then
        return 1
    fi

    rm -rf "${TMP_7Z_DIR}" >/dev/null 2>>"${LOG_PATH}"

    return 0
}



#
# MAIN SCRIPT
#

# The argument passed to this script is the string we want to look for in the XP files
# in order to retrieve the resource ID.
#
#     ./scanstr.sh 
#
if [[ ! -d "${SOURCE_XP_DIR}" ]]
then
    echo 'Cannot find XP source files - have you ran muiprep.sh yet?'
    exit 1
fi

if [[ ! -f "${SH_MUI2ISO}" ]]
then
    echo "mui2iso script is missing? It should be at ${SH_MUI2ISO}"
    exit 1
fi

# Search through XP source files that contain the string we're looking for, then build
# an array that prioritises certain files (eg. explorer.exe)
#
declare -a final_files
readarray -t matched_files < <(rg --text --files-with-matches -E 'utf-16' "${1}" "${SOURCE_XP_DIR}")

for priority_file in "${FILE_PRIORITY[@]}"
do
    # Look for this file in the matched files
    #
    for search_file in "${matched_files[@]}"
    do
        search_file_basename=`basename "${search_file}"`

        if [[ "${search_file_basename}" == "${priority_file}" ]]
        then
            final_files+=("${search_file}")
        fi
    done
done

for matched_file in "${matched_files[@]}"
do
    # Skip .strings files
    #
    if [[ "${matched_file}" =~ \.strings$ ]]
    then
        continue
    fi

    # Add any remaining files in here
    #
    for present_file in "${final_files[@]}"
    do
        if [[ "${matched_file}" == "${present_file}" ]]
        then
            continue 2
        fi
    done

    final_files+=("${matched_file}")
done

# Now iterate through the files and look for the string
#
for res_file in "${final_files[@]}"
do
    found_strings=0
    res_cache_file="${res_file}.strings"
    res_file_basename=`basename "${res_file}"`
    res_id=0
    res_mui_basename="${res_file_basename}.mui"

    # Ensure there is a cached copy of the string table
    #
    cache_strings "${res_file}"

    if [[ $? -gt 0 ]]
    then
        continue
    fi

    # Try to retrieve the resource ID for the string
    #
    res_id=`rg --no-line-number -E 'utf-16' "^\d+\s+${1}.$" "${res_cache_file}" | cut -f1`

    if [[ "${res_id}" -eq 0 ]]
    then
        continue
    fi

    # Now examine the MUIs to find translations for the file
    #
    while IFS= read -r mui_dir
    do
        mui_string=""
        res_mui_file="${mui_dir}/${res_mui_basename}"
        res_mui_cache_file="${res_mui_file}.strings"

        if [[ ! -f "${res_mui_file}" ]]
        then
            continue
        fi

        # Ensure a cached copy of the string table for the MUI
        #
        cache_strings "${res_mui_file}"

        # Try to retrieve the translated string
        #
        mui_string=`rg --no-line-number -E 'utf-16' "${res_id}\s+.+" "${res_mui_cache_file}" | cut -f2`

        if [[ "${mui_string}" != "" ]]
        then
            found_strings=1
        fi

        # Format and output
        #
        mui_code=`basename "${mui_dir}"`
        iso_code=`${SH_MUI2ISO} "${mui_code}"`

        if [[ $? -gt 0 ]]
        then
            echo "Failed to retrieve ISO code for ${mui_code}"
            exit 1
        fi

        echo "${iso_code}#${mui_string}" # Use a hash as the delimiter
    done < <(find "${MUIS_DIR}" -maxdepth 1 -type d -not -name '.' -a -not -name 'xp')

    # If we found strings successfully - exit
    #
    if [[ "${found_strings}" -eq 1 ]]
    then
        exit 0
    fi
    echo "${found_strings}"
done

# Failed to find the string!
#
echo -n "String not found."
exit 1
