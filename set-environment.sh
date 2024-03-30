#! /bin/bash

shopt -s dotglob
for DIR in ./*; do
    if [[ "${DIR}" == "./.git" || "${DIR}" == "./set-environment.sh" ]]; then
        continue
    elif [[ "${DIR}" == "./.config" ]]; then
        for CONFIG_DIR in ${DIR}/*; do
            ln -s ~/dot/${CONFIG_DIR} ~/${CONFIG_DIR#./}
        done
        continue
    fi
    ln -s ~/dot/${DIR} ~/${DIR#./}
done
shopt -s dotglob
