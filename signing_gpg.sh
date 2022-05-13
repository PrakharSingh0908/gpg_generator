#!/bin/bash
echo "########### Options ###############
Press 1- To create a new gpg key
Press 2- To use the current gpg key"
read input

if [[ $input -eq 1 ]]
then
    gpg --full-generate-key
    echo "Your key has been successfully generated!"
    bash signing_gpg.sh
fi

if [[ $input -eq 2 ]]
then
    gpgkey=$(gpg --list-secret-keys --keyid-format=long)
    keysize=${#gpgkey}
    if [ $keysize ]
        then
            echo "Available gpg keys are -"
        else
            echo "There are no existing gpg keys, please generate one -"
            gpg --full-generate-key
        fi
    gpg --list-secret-keys --keyid-format=long
    echo "The respective keyID of the gpg keys with their indexes are - "
    key=$(gpg --list-secret-keys --keyid-format=long|awk '/sec/{if (length($2)>0) print $2}')
    declare -a keyArray

    n1=${#key}

    j=0
    keyIndex=0

    for((i=0;i<$n1;i++));
    do
    if [[ ${key:$i:1} == "/" ]]
        then
        keyArray[$j]=${key:$i+1:16}
        k=`expr $j + 1`
        echo Index = $k KeyId = ${keyArray[j]}
        ((j++))
        fi
    done

    echo "Type the Index of GPG key to be used"
    read keyIndex
    echo "Copy the following public key to paste on your GitHub's gpg key"
    gpg --armor --export ${keyArray[keyIndex - 1]}
    
else
echo "Choose a right option"
fi
