#!/bin/bash

USAGE='Usage: ./run.sh [OPTIONS]
\n\nOptions:
\n\t --servers \t Sets the number of servers (default 3)
\n\t --clients \t Sets the number of clients (default 3)
\n\nRuns a N clients that send messages to M servers that perform async operations and send the responses to their client.'

SERVERS=3
CLIENTS=3

for i in "$@"
do
case $i in
-h|--help)
  echo -e $USAGE
  exit 1
  ;;
--servers=*)
  SERVERS="${i#*=}"
  ;;
--clients=*)
  CLIENTS="${i#*=}"
  ;;
esac
done

echo "Building solution"
dotnet build

echo "Starting $SERVERS servers"
for ((i=1; i<=$SERVERS; i++))
do 
  dotnet run src/Backend/Backend.csproj
done
wait

sleep 5000

echo "Starting $CLIENTS clients"
for ((i=1; i<=$CLIENTS; i++))
do 
  dotnet run src/Client/Client.csproj
done
wait

echo "Process finished"