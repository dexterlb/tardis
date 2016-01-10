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

	err = spiDevice.SetMode(0)
	if err != nil {
		log.Fatal(err)
		return
	}

	err = spiDevice.SetBitsPerWord(8)
	if err != nil {
		log.Fatal(err)
		return
	}

	err = spiDevice.SetSpeed(5000)
	if err != nil {
		log.Fatal(err)
		return
	}

	data, err := spiDevice.Send([]byte{1, 2, 3, 4})

	if err != nil {
		log.Print(err)
	} else {
		fmt.Printf("data: %v\n", data)
	}
}
