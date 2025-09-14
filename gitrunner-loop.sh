export firstrun=true
while true; do
    ./gitrunner.sh
    export firstrun=false
    sleep 15
done
