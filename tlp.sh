#!/bin/sh


run_tlp() {
	# dom0
	PATH=$PATH:/usr/local/bin:/usr/local/sbin sudo /usr/local/sbin/tlp "$1"
	# VMs
	for i in sys-net sys-usb sys-firewall work untrusted; do
		qvm-run $i "sudo tlp $MODE"
	done
}

MODE="$1"

MIN_FREQ=
MAX_FREQ=
MAX_MIN_FREQ=$(sudo xenpm get-cpufreq-para 0 | sed -ne 's/^cpuinfo frequency.*max \[\([0-9]\+\)\].*min \[\([0-9]\+\)\].*/\1|\2/p')
if [ $? -eq 0 ]; then
	MIN_FREQ=${MAX_MIN_FREQ#*|}
	MAX_FREQ=${MIN_MIN_FREQ%|*}
else
	echo "Couldn't get min/max cpu freq; won't set frequency thresholds" >&2
fi

sudo xenpm set-scaling-governor ondemand

case "$MODE" in
	"bat")
		run_tlp bat
		#sudo xenpm set-scaling-governor powersave
		sudo xenpm set-sched-smt enable
		sudo xenpm set-vcpu-migration-delay 1000
		sudo xenpm disable-turbo-mode
		[ -n "$MIN_FREQ" ] && sudo xenpm set-scaling-maxfreq 1500000
		;;
	"ac")
		run_tlp ac
		#sudo xenpm set-scaling-governor ondemand
		sudo xenpm set-sched-smt enable
		sudo xenpm set-vcpu-migration-delay 0
		sudo xenpm enable-turbo-mode
		[ -n "$MAX_FREQ" ] && sudo xenpm set-scaling-maxfreq 2601000
		;;
	*)
		echo "Not a supported mode: '$MODE'" >&2
		exit 1
esac
