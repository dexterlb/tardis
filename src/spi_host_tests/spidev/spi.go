package main

import (
	"fmt"
	"log"

	"github.com/luismesas/goPi/spi"
)

func main() {
	spiDevice := spi.NewSPIDevice(0, 0)
	err := spiDevice.Open()
	if err != nil {
		log.Fatal(err)
		return
	}

	data, err := spiDevice.Send([3]byte{3, 42, 5})

	if err != nil {
		fmt.Printf("data: %s\n", data)
	} else {
		log.Print(err)
	}
}
