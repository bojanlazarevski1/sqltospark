#!/usr/bin/env bash

#
# Copyright (C) 2019 Transaction Processing Performance Council (TPC) and/or its contributors.
# This file is part of a software package distributed by the TPC
# The contents of this file have been developed by the TPC, and/or have been licensed to the TPC under one or more contributor
# license agreements.
# This file is subject to the terms and conditions outlined in the End-User
# License Agreement (EULA) which can be found in this distribution (EULA.txt) and is available at the following URL:
# http://www.tpc.org/TPC_Documents_Current_Versions/txt/EULA.txt
# Unless required by applicable law or agreed to in writing, this software is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied, and the user bears the entire risk as to quality
# and performance as well as the entire cost of service or repair in case of defect. See the EULA for more details.
#
#


#
# Copyright 2015-2019 Intel Corporation.
# This software and the related documents are Intel copyrighted materials, and your use of them
# is governed by the express license under which they were provided to you ("License"). Unless the
# License provides otherwise, you may not use, modify, copy, publish, distribute, disclose or
# transmit this software or the related documents without Intel's prior written permission.
#
# This software and the related documents are provided as is, with no express or implied warranties,
# other than those that are expressly stated in the License.
#
#

trap INTERRUPT_SIGNAL 1 2 3 6

current_step=0

run_sequence(){
        ## ===================================================
        ## determine base directory
        ## ===================================================
        cd "$(dirname ${BASH_SOURCE[0]})/"
        export BIG_BENCH_BIN="$PWD"
        cd "$OLDPWD"


        ## ===================================================
        ## run validation test (Step 1/3)
        ## ===================================================
        current_step=1
        echo "Running step 1/3 of benchmark: bin/TPCxBB_Validation.sh"
        . "$BIG_BENCH_BIN/TPCxBB_Validation.sh"
        return_code_validation_test=$?
        if [ ${return_code_validation_test} -ne 0 ]; then
           echo "Error: Running step 1/3 (bin/TPCxBB_Validation.sh) of benchmark sequence failed."
           exit ${return_code_validation_test}
        fi

        ## ===================================================
        ## run benchmark first time (Step 2/3)
        ## ===================================================
        current_step=2
        echo "Running step 2/3 of benchmark: bin/TPCxBB_Benchmarkrun.sh"
        . "$BIG_BENCH_BIN/TPCxBB_Benchmarkrun.sh"
        return_code_benchmark_test=$?
        if [ ${return_code_benchmark_test} -ne 0 ]; then
           echo "Error: Running step 2/3 (bin/TPCxBB_Benchmarkrun.sh) of benchmark sequence failed."
           exit ${return_code_benchmark_test}
        fi


        ## ===================================================
        ## run benchmark second time (Step 3/3)
        ## ===================================================
        current_step=3
        echo "Running step 3/3 of benchmark: bin/TPCxBB_Benchmarkrun.sh"
        . "$BIG_BENCH_BIN/TPCxBB_Benchmarkrun.sh"
        return_code_benchmark_test=$?
        if [ ${return_code_benchmark_test} -ne 0 ]; then
           echo "Error: Running step 3/3 (bin/TPCxBB_Benchmarkrun.sh) of benchmark sequence failed."
           exit ${return_code_benchmark_test}
        fi

}

INTERRUPT_SIGNAL(){
   echo "Caught Interrupt/Quit Signal while running step ${current_step}/3  of full benchmark sequence. Exiting..."
   exit 1
}

run_sequence
