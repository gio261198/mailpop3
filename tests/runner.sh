#!/bin/sh

print_title() {
	echo -e "\033[1;30mTesting ${1}\033[0;30m";
}

print_test() {
	printf "%-60s" "$1";
}

print_result() {

	echo $* | grep -q "fail"

	# $1: 0 is expecting no failure, 1 is expecting failure
	if [ $? -eq $1 ]; then
		FAILCOUNT=`expr $FAILCOUNT + 1`
		echo -e " [\033[1;31mFAIL\033[0;30m]";
	else
		PASSCOUNT=`expr $PASSCOUNT + 1`
		echo -e " [\033[1;32mPASS\033[0;30m]";
	fi

}

echo "runner.sh v0.1 - a test runner utility"
echo "Copyright (c) 2011 Ditesh Shashikant Gathani <ditesh@gathani.org>"

if [ $# -lt 6 ]; then

	echo "Usage:"
	echo "	runner.sh username password host standard-port tls-port testemail@example.com [test]"
	echo
	echo "	username: 	POP3 username"
	echo "	password: 	POP3 password"
	echo "	host:		POP3 host"
	echo "	standard-port:	POP3 port (eg 110)"
	echo "	tls-port: 	POP3 TLS port (eg 995)"
	echo "	email: 		valid email address on POP3 server which can receive emails"
	echo "	test: 		which test to run (default all)"
	echo
	exit 1

fi

USER=$1
PASS=$2
HOST=$3
PORT=$4
TLSPORT=$5
EMAIL=$6
FAILCOUNT=0
PASSCOUNT=0

if [ $# -eq 7 ]; then

	echo
	source ./$7

else

	echo
	source ./login.sh
	echo
	source ./basic.sh
	echo
	source ./apop.sh
	echo
	source ./stls.sh
	echo
	source ./tls.sh

fi

echo
echo -e "\033[1;30mSummary:"
echo -e "	\033[1;32mPassed tests: ${PASSCOUNT}\033[0;30m"
echo -e "	\033[1;31mFailed tests: ${FAILCOUNT}\033[0;30m"
echo
