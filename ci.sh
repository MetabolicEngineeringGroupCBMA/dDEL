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
    conda config --append channels conda-forge
    conda config --append channels BjornFJohansson
else
    echo "Not running on CI server, probably running on local computer"
    local_computer=true
fi

conda create -y -n dDEL_testenv python=3.6 nbval pytest beautifulsoup4 lxml requests
source activate dDEL_testenv
which python
python --version
conda install pydna
conda install pygenome
python run_test.py
if [[ $local_computer = true ]]
then
    source activate bjorn36
    conda remove -n dDEL_testenv --all -q
fi
