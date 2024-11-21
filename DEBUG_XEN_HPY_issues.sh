#Objective comprehensive script that monitors the five major issues related to Xen hypervisors and OpenStack


#HOW it works

# Explanation:
#1. Performance Overhead: Uses top to monitor CPU load and check for performance bottlenecks.
#2. Networking Issues: Uses ip a to show network interfaces and ifstat for performance.
#3. Hardware Support: Uses dmesg to check for hardware-related errors.
#4. Resource Contention: Uses vmstat to monitor system resource usage.
#5. Management Issues: Monitors Xen management logs for errors using tail.


#!/bin/bash

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script should be run as root for complete monitoring."
    exit 1
fi

# Function to check performance overhead (CPU load)
check_performance_overhead() {
    echo "Checking CPU performance..."
    top -b -n 1 | head -20
    echo ""
}

# Function to check for networking issues
check_networking() {
    echo "Checking network status..."
    ip a | grep 'inet'
    echo "Checking network interfaces performance..."
    ifstat -t 1 1
    echo ""
}

# Function to check hardware support (dmesg logs for hardware-related errors)
check_hardware_support() {
    echo "Checking hardware support..."
    dmesg | grep -i error
    echo ""
}

# Function to check resource contention (Memory and CPU usage)
check_resource_contention() {
    echo "Checking resource contention..."
    vmstat 1 5
    echo ""
}

# Function to check management status (Xen-related logs)
check_management() {
    echo "Checking Xen management logs..."
    tail -n 20 /var/log/xen/xend.log
    echo ""
}

# Display instructions
echo "Xen Hypervisor Monitoring Script"
echo "Press [CTRL+C] to stop the monitoring."
echo "---------------------------------"
echo ""

# Continuous monitoring loop
while true; do
    check_performance_overhead
    check_networking
    check_hardware_support
    check_resource_contention
    check_management
    sleep 5
done
