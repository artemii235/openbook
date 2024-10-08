#!/bin/bash

# Set the base command for place
PLACE_COMMAND="RUST_LOG=debug openbook v1 -m 44WSjGcKyFuAWLSCqtVfnjHcTcG6uVWQZ6SYEpkZpc4f place -t 10. -b 0. -e"

# Set the cancel command
CANCEL_COMMAND="RUST_LOG=debug openbook v1 -m 44WSjGcKyFuAWLSCqtVfnjHcTcG6uVWQZ6SYEpkZpc4f cancel -e"

SETTLE_COMMAND="RUST_LOG=debug openbook v1 -m 44WSjGcKyFuAWLSCqtVfnjHcTcG6uVWQZ6SYEpkZpc4f settle -e"

# Set the delay between iterations (in seconds)
# 0.1 seconds = 100 milliseconds
DELAY=0.1

# Function to generate a random price between 1.00 and 1.99
generate_random_price() {
    awk 'BEGIN{srand(); printf "%.2f", 1+rand()*0.99}'
}

# Function to generate a random price between 2.00 and 2.99
generate_random_price_2() {
    awk 'BEGIN{srand(); printf "%.2f", 2+rand()*0.99}'
}

# Function to run the place command with a random price
run_place_command() {
    RANDOM_PRICE=$(generate_random_price)
    RANDOM_PRICE_2=$(generate_random_price_2)
    FULL_COMMAND_BID="$PLACE_COMMAND -p $RANDOM_PRICE -s BID"
    #echo "Running place command: $FULL_COMMAND"
    eval $FULL_COMMAND_BID
    FULL_COMMAND_ASK="$PLACE_COMMAND -p $RANDOM_PRICE_2 -s ASK"
    eval $FULL_COMMAND_ASK
    eval $SETTLE_COMMAND
    #echo $($RANDOM_PRICE_2 + 0.1)
    #FULL_COMMAND_ASK_MORE="$PLACE_COMMAND -p $RANDOM_PRICE_2 -s ASK"
    #eval $FULL_COMMAND_ASK
    #echo "Place command completed. Waiting $DELAY seconds before next iteration..."
}

# Function to run the cancel command
run_cancel_command() {
    #echo "Running cancel command: $CANCEL_COMMAND"
    eval $CANCEL_COMMAND
    #echo "Cancel command completed. Waiting $DELAY seconds before next iteration..."
}

# Initialize counter
counter=0

# Main loop
while true; do
    # Increment counter
    ((counter++))
    
    # Run place command
    run_place_command
    
    # If counter reaches 8, run cancel command and reset counter
    if [ $counter -eq 8 ]; then
        run_cancel_command
        counter=0
    fi
    
    sleep $DELAY
done
