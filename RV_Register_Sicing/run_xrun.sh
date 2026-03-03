
#!/usr/bin/env bash
set -euo pipefail

# usage:
#   ./run_xrun.sh                 # default smoke, random seed
#   ./run_xrun.sh rv_test 12345    # fixed seed
#   COV=0 ./run_xrun.sh rv_test 1  # disable coverage
#   VERB=UVM_HIGH ./run_xrun.sh rv_test 1

#!/usr/bin/env bash
set -euo pipefail

# 以腳本所在位置當作專案根目錄
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TEST=${1:-rv_test}
SEED=${2:-random}
VERB=${VERB:-UVM_MEDIUM}
COV=${COV:-1}

COV_OPT=""
if [[ "${COV}" == "1" ]]; then
  COV_OPT="-coverage functional"
fi

# 你有 filelist 就用 filelist（最推薦）
if [[ -f "${ROOT}/sim/filelist.f" ]]; then
  xrun -64bit -sv -uvm \
    -access +rw \
    -seed "${SEED}" \
    ${COV_OPT} \
    +UVM_TESTNAME="${TEST}" \
    +UVM_VERBOSITY="${VERB}" \
    -l "${ROOT}/xrun_${TEST}_${SEED}.log" \
    -f "${ROOT}/sim/filelist.f"
else
  # 沒 filelist 的話：請把下面兩行改成你現在實際檔案位置
  xrun -64bit -sv -uvm \
    -access +rw \
    -seed "${SEED}" \
    ${COV_OPT} \
    +UVM_TESTNAME="${TEST}" \
    +UVM_VERBOSITY="${VERB}" \
    -l "${ROOT}/xrun_${TEST}_${SEED}.log" \
    "${ROOT}/rtl/design.sv" \
    "${ROOT}/tb/top/testbench.sv"
fi

















