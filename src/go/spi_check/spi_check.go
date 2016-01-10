package main

import (
	"log"

	"github.com/luismesas/goPi/spi"
)

func initSpi() (*spi.SPIDevice, error) {
	spiDevice := spi.NewSPIDevice(0, 0)
	err := spiDevice.Open()
	if err != nil {
		return nil, err
	}

	err = spiDevice.SetMode(0)
	if err != nil {
		return nil, err
	}

	err = spiDevice.SetBitsPerWord(8)
	if err != nil {
		return nil, err
	}

	err = spiDevice.SetSpeed(5000)
	if err != nil {
		return nil, err
	}

	return spiDevice, nil
}

func main() {
	spiDevice, err := initSpi()
	if err != nil {
		log.Print(err)
		return
	}

	data, err := spiDevice.Send([]byte{1, 2, 3, 4})
	if err != nil {
		log.Print(err)
		return
	}

	log.Printf("got data: %v\n", data)
}
