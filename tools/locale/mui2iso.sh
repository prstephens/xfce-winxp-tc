#!/bin/bash

#
# mui2iso.sh - Get ISO 639-1 Code from MUI Language Code
#
# This source-code is part of Windows XP stuff for XFCE:
# <<https://www.oddmatics.uk>>
#
# Author(s): Rory Fewell <roryf@oddmatics.uk>
#

#
# ARGUMENTS
#
if [[ $# -eq 0 ]] || [[ "${1}" -eq "--help" ]]
then
    echo 'mui2iso.sh - Converts MUI langauge code to ISO 639-1'
    echo ''
    echo 'This script is a helper for retrieving the ISO 639-1 language code (used by'
    echo 'gettext) associated with a MUI code (used by Windows).'
    echo ''
    echo 'Note that this is for MUI codes such as FR or JPN, not the numerical codes'
    echo 'like 040e. This is because this the directory names in the sources use the'
    echo 'former rather than the latter.'
    echo ''
    echo 'Usage:'
    echo '    mui2iso.sh <mui code>'
    echo ''
    echo 'Example:'
    echo '    mui2iso.sh SK'
    echo ''
    exit 0
fi

if [[ $# -gt 1 ]]
then
    echo 'Too many arguments!'
    echo 'Usage: mui2iso.sh <mui code> OR mui2iso.sh for detailed usage'
    exit 1
fi



#
# MAIN SCRIPT
#

# The argument passed to this script is a Windows MUI code (not the numeric kind), we
# just translate it to an ISO 639-1 code in the standard output.
#
mui_code="${1}"

case "${mui_code}" in
    # Arabic - Saudi Arabia
    #
    'ARA')
        echo -n 'ar_SA'
        ;;

    # Bulgarian - Bulgaria
    #
    'BG')
        echo -n 'bg_BG'
        ;;

    # Portuguese - Brazil
    #
    'BR')
        echo -n 'pt_BR'
        ;;

    # Chinese (Traditional) - Taiwan
    #
    'CHH')
        echo -n 'zh_TW'
        ;;

    # Chinese (Simplified) - China
    #
    'CHS')
        echo -n 'zh_CN'
        ;;

    # Czech - Czech Republic
    #
    'CS')
        echo -n 'cs_CZ'
        ;;

    # Danish - Denmark
    #
    'DA')
        echo -n 'da_DK'
        ;;

    # Greek - Greece
    #
    'EL')
        echo -n 'el_GR'
        ;;

    # Spanish - Spain
    #
    'ES')
        echo -n 'es_ES'
        ;;

    # Estonian - Estonia
    #
    'ET')
        echo -n 'et_EE'
        ;;

    # Finnish -Finland
    #
    'FI')
        echo -n 'fi_FI'
        ;;

    # French - France
    #
    'FR')
        echo -n 'fr_FR'
        ;;

    # German - Germany
    #
    'GER')
        echo -n 'de_DE'
        ;;

    # Hebrew - Israel
    #
    'HEB')
        echo -n 'he_IL'
        ;;

    # Croatian - Croatia
    #
    'HR')
        echo -n 'hr_HR'
        ;;

    # Hungarian - Hungary
    #
    'HU')
        echo -n 'hu_HU'
        ;;

    # Italian - Italy
    #
    'IT')
        echo -n 'it_IT'
        ;;

    # Japanese - Japan
    #
    'JPN')
        echo -n 'ja_JP'
        ;;

    # Korean - Korea
    #
    'KOR')
        echo -n 'ko_KR'
        ;;

    # Lithuanian - Lithuania
    #
    'LT')
        echo -n 'lt_LT'
        ;;

    # Latvian - Latvia
    #
    'LV')
        echo -n 'lv_LV'
        ;;

    # Dutch - Netherlands
    #
    'NL')
        echo -n 'nl_NL'
        ;;

    # Norwegian - Norway
    #
    'NO')
        echo -n 'nb_NO'
        ;;

    # Polish - Poland
    #
    'PL')
        echo -n 'pl_PL'
        ;;

    # Portuguese - Portugal
    #
    'PT')
        echo -n 'pt_PT'
        ;;

    # Romanian - Romania
    #
    'RO')
        echo -n 'ro_RO'
        ;;

    # Russian - Russia
    #
    'RU')
        echo -n 'ru_RU'
        ;;

    # Slovak - Slovakia
    #
    'SK')
        echo -n 'sk_SK'
        ;;

    # Slovenian - Slovenia
    #
    'SL')
        echo -n 'sl_SI'
        ;;

    # Swedish - Sweden
    #
    'SV')
        echo -n 'sv_SE'
        ;;

    # Thai - Thailand
    #
    'TH')
        echo -n 'th_TH'
        ;;

    # Turkish - Turkey
    #
    'TR')
        echo -n 'tr_TR'
        ;;

    *)
        echo -n 'Unknown MUI code.'
        exit 1
        ;;
esac
