#!/usr/bin/env bash
if [[ $CI = true ]]||[[ $CI = True ]]
then
    echo "Running on CI server"
    wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda_latest.sh
    bash Miniconda_latest.sh -b -p $HOME/miniconda
    export PATH="$HOME/miniconda/bin:$PATH"
    rm Miniconda_latest.sh
    conda config --set always_yes yes --set show_channel_urls yes
    conda update conda
else
    echo "Not running on CI server, probably running on local computer"
    local_computer=true
fi

echo "create test environment for python 3.6"
conda env create -f conda_envs/testenv36.yml
source activate testenv36
python run_test.py
if [[ $local_computer = true ]]
then
    source activate bjorn36
    conda remove -n testenv36 --all -q
fi
