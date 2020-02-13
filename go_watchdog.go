package main

import (
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"time"
)

var loger *log.Logger

func init() {
	f, err := os.OpenFile("/var/log/go_watchdog.log",
		os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Println(err)
	}

	loger = log.New(f, "For My RuiRui", log.LstdFlags)
}

func main() {
	http.HandleFunc("/build", handleBuild)
	http.ListenAndServe(":19999", nil)
}

// 触发执行脚本
func handleBuild(w http.ResponseWriter, r *http.Request) {
	loger.Println("Build at: ", time.Now())
	io.WriteString(w, "Building...")

	// 执行容器，拉取代码，镜像等操作
	cmd := exec.Command("bash", "watchdog.sh")
	cmd.Stdin = strings.NewReader("")
	//var out bytes.Buffer
	//cmd.Stdout = &outs
	cmd.Stdout = loger.Writer()
	err := cmd.Run()
	if err != nil {
		log.Fatal(err)
	}
}
