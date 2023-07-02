package rlimit

import (
	"fmt"
	"syscall"
)

var Debug = false

func Increase() error {
	return Set(65535)
}

func Get() syscall.Rlimit {
	var rLimit syscall.Rlimit
	err := syscall.Getrlimit(syscall.RLIMIT_NOFILE, &rLimit)
	if err != nil {
		fmt.Println("error getting Rlimit ", err)
	}
	return rLimit
}

func Set(value uint64) error {
	var rLimit = Get()
	if Debug {
		fmt.Printf("current rlimit: soft %v / hard %v\n", rLimit.Cur, rLimit.Max)
	}

	rLimit.Max = value
	rLimit.Cur = value
	err := syscall.Setrlimit(syscall.RLIMIT_NOFILE, &rLimit)
	if err != nil {
		return fmt.Errorf("error setting rlimit %v", err)
	}

	rLimit = Get()
	if Debug {
		fmt.Printf("final rlimit: soft %v / hard %v\n", rLimit.Cur, rLimit.Max)
	}
	return nil
}
