# Step 1: Define NS Simulator instance
set ns [new Simulator]

# Step 2: Open trace and nam files
set tracefile [open out.tr w]
$ns trace-all $tracefile
set namfile [open out.nam w]
$ns namtrace-all $namfile

# Step 3: Define the topology (smart city with vehicles and RSUs)

# Create vehicles (V2V communication)
set vehicle1 [$ns node]
set vehicle2 [$ns node]
set vehicle3 [$ns node]
set vehicle4 [$ns node]

# Create RSUs (V2R communication)
set rsu1 [$ns node]
set rsu2 [$ns node]

# Step 4: Set up communication links (wireless communication for vehicles and RSUs)
$ns duplex-link $vehicle1 $vehicle2 1Mb 10ms DropTail
$ns duplex-link $vehicle3 $vehicle4 1Mb 10ms DropTail
$ns duplex-link $vehicle1 $rsu1 1Mb 10ms DropTail
$ns duplex-link $vehicle2 $rsu2 1Mb 10ms DropTail

# Step 5: Define traffic (TCP communication between vehicles and RSUs)

# Vehicle 1 to RSU 1 (TCP traffic)
set tcp1 [new Agent/TCP]
$ns attach-agent $vehicle1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $rsu1 $sink1

$ns connect $tcp1 $sink1

# Vehicle 2 to RSU 2 (TCP traffic)
set tcp2 [new Agent/TCP]
$ns attach-agent $vehicle2 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $rsu2 $sink2

$ns connect $tcp2 $sink2

# Step 6: Set up a routing protocol (e.g., DSR, AODV, or DSDV)
# Example: DSR
$ns rtproto DSR

# Step 7: Schedule traffic transmission
$ns at 0.5 "$tcp1 send"
$ns at 1.0 "$tcp2 send"

# Step 8: Finish simulation at a specific time
$ns at 5.0 "finish"

proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam out.nam &
    exit 0
}

# Step 9: Start simulation
$ns run
