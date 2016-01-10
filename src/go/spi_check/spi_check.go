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

	data, err := spiDevice.Send([3]byte{3, 42, 5})

	if err != nil {
		fmt.Printf("data: %v\n", data)
	} else {
		fmt.Printf("data: %v\n", data)
		log.Print(err)
	}
}
