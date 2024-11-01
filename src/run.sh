sudo perf stat -e "power/energy-pkg/" record -o perf_results.txt timeout 650 npm run dev

