EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:amplifier-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L C C?
U 1 1 5508A99C
P 3650 3100
F 0 "C?" H 3650 3200 40  0000 L CNN
F 1 "1n" H 3656 3015 40  0000 L CNN
F 2 "" H 3688 2950 30  0000 C CNN
F 3 "" H 3650 3100 60  0000 C CNN
	1    3650 3100
	1    0    0    -1  
$EndComp
$Comp
L INDUCTOR_SMALL L?
U 1 1 5508A9D9
P 4050 2800
F 0 "L?" H 4050 2900 50  0000 C CNN
F 1 "INDUCTOR_SMALL" H 4050 2750 50  0001 C CNN
F 2 "" H 4050 2800 60  0000 C CNN
F 3 "" H 4050 2800 60  0000 C CNN
	1    4050 2800
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 5508AA13
P 3400 3100
F 0 "C?" H 3400 3200 40  0000 L CNN
F 1 "100n" H 3406 3015 40  0000 L CNN
F 2 "" H 3438 2950 30  0000 C CNN
F 3 "" H 3400 3100 60  0000 C CNN
	1    3400 3100
	1    0    0    -1  
$EndComp
$Comp
L INDUCTOR_SMALL L?
U 1 1 5508AA61
P 5350 2800
F 0 "L?" H 5350 2900 50  0000 C CNN
F 1 "INDUCTOR_SMALL" H 5350 2750 50  0001 C CNN
F 2 "" H 5350 2800 60  0000 C CNN
F 3 "" H 5350 2800 60  0000 C CNN
	1    5350 2800
	1    0    0    -1  
$EndComp
$Comp
L CP2 C?
U 1 1 5508AD94
P 3150 3100
F 0 "C?" H 3150 3200 40  0000 L CNN
F 1 "1000u" H 3156 3015 40  0000 L CNN
F 2 "" H 3188 2950 30  0000 C CNN
F 3 "" H 3150 3100 60  0000 C CNN
	1    3150 3100
	1    0    0    -1  
$EndComp
$Comp
L LM386 U?
U 1 1 5508B54C
P 6650 4300
F 0 "U?" H 6900 4400 60  0000 C CNN
F 1 "LM386" H 7000 4200 60  0000 C CNN
F 2 "" H 6650 4300 60  0000 C CNN
F 3 "" H 6650 4300 60  0000 C CNN
	1    6650 4300
	1    0    0    -1  
$EndComp
$Comp
L CP2 C?
U 1 1 55095397
P 6750 5050
F 0 "C?" H 6800 4950 40  0000 L CNN
F 1 "10u" H 6800 5150 40  0000 L CNN
F 2 "" H 6788 4900 30  0000 C CNN
F 3 "" H 6750 5050 60  0000 C CNN
	1    6750 5050
	1    0    0    1   
$EndComp
$Comp
L POT R?
U 1 1 550B26B6
P 6400 5350
F 0 "R?" H 6250 5450 50  0000 C CNN
F 1 "2.2k" H 6400 5350 50  0000 C CNN
F 2 "" H 6400 5350 60  0000 C CNN
F 3 "" H 6400 5350 60  0000 C CNN
	1    6400 5350
	1    0    0    -1  
$EndComp
$Comp
L CP2 C?
U 1 1 550B28F7
P 7550 4300
F 0 "C?" V 7400 4250 40  0000 L CNN
F 1 "250u" V 7700 4250 40  0000 L CNN
F 2 "" H 7588 4150 30  0000 C CNN
F 3 "" H 7550 4300 60  0000 C CNN
	1    7550 4300
	0    1    1    0   
$EndComp
$Comp
L SPEAKER SP?
U 1 1 550B2A18
P 8150 4400
F 0 "SP?" H 8050 4650 70  0000 C CNN
F 1 "SPEAKER" H 8050 4150 70  0000 C CNN
F 2 "" H 8150 4400 60  0000 C CNN
F 3 "" H 8150 4400 60  0000 C CNN
	1    8150 4400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B2ADB
P 7700 4550
F 0 "#PWR?" H 7700 4300 60  0001 C CNN
F 1 "GND" H 7700 4400 60  0001 C CNN
F 2 "" H 7700 4550 60  0000 C CNN
F 3 "" H 7700 4550 60  0000 C CNN
	1    7700 4550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B2E7D
P 6550 4750
F 0 "#PWR?" H 6550 4500 60  0001 C CNN
F 1 "GND" H 6550 4600 60  0001 C CNN
F 2 "" H 6550 4750 60  0000 C CNN
F 3 "" H 6550 4750 60  0000 C CNN
	1    6550 4750
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 550B3B9B
P 7250 4650
F 0 "R?" H 7350 4700 40  0000 C CNN
F 1 "10" H 7350 4600 40  0000 C CNN
F 2 "" V 7180 4650 30  0000 C CNN
F 3 "" H 7250 4650 30  0000 C CNN
	1    7250 4650
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 550B3DD3
P 7250 5150
F 0 "C?" H 7250 5250 40  0000 L CNN
F 1 "50n" H 7256 5065 40  0000 L CNN
F 2 "" H 7288 5000 30  0000 C CNN
F 3 "" H 7250 5150 60  0000 C CNN
	1    7250 5150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B3F23
P 7250 5400
F 0 "#PWR?" H 7250 5150 60  0001 C CNN
F 1 "GND" H 7250 5250 60  0001 C CNN
F 2 "" H 7250 5400 60  0000 C CNN
F 3 "" H 7250 5400 60  0000 C CNN
	1    7250 5400
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B3F9B
P 6100 4750
F 0 "#PWR?" H 6100 4500 60  0001 C CNN
F 1 "GND" H 6100 4600 60  0001 C CNN
F 2 "" H 6100 4750 60  0000 C CNN
F 3 "" H 6100 4750 60  0000 C CNN
	1    6100 4750
	1    0    0    -1  
$EndComp
$Comp
L POT R?
U 1 1 550B40C6
P 5050 4200
F 0 "R?" V 4900 4300 50  0000 C CNN
F 1 "10k" H 5050 4200 50  0000 C CNN
F 2 "" H 5050 4200 60  0000 C CNN
F 3 "" H 5050 4200 60  0000 C CNN
	1    5050 4200
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 550B41F6
P 5050 4500
F 0 "#PWR?" H 5050 4250 60  0001 C CNN
F 1 "GND" H 5050 4350 60  0001 C CNN
F 2 "" H 5050 4500 60  0000 C CNN
F 3 "" H 5050 4500 60  0000 C CNN
	1    5050 4500
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X03 P?
U 1 1 550B44F8
P 4200 4000
F 0 "P?" H 4200 4200 50  0000 C CNN
F 1 "AUDIO_IN" V 4300 4000 50  0000 C CNN
F 2 "" H 4200 4000 60  0000 C CNN
F 3 "" H 4200 4000 60  0000 C CNN
	1    4200 4000
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR?
U 1 1 550B460A
P 4500 4500
F 0 "#PWR?" H 4500 4250 60  0001 C CNN
F 1 "GND" H 4500 4350 60  0001 C CNN
F 2 "" H 4500 4500 60  0000 C CNN
F 3 "" H 4500 4500 60  0000 C CNN
	1    4500 4500
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X02 P?
U 1 1 550B4765
P 2450 2850
F 0 "P?" H 2450 3000 50  0000 C CNN
F 1 "POWER" H 2450 2700 50  0000 C CNN
F 2 "" H 2450 2850 60  0000 C CNN
F 3 "" H 2450 2850 60  0000 C CNN
	1    2450 2850
	-1   0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B4858
P 2750 3350
F 0 "#PWR?" H 2750 3100 60  0001 C CNN
F 1 "GND" H 2750 3200 60  0001 C CNN
F 2 "" H 2750 3350 60  0000 C CNN
F 3 "" H 2750 3350 60  0000 C CNN
	1    2750 3350
	1    0    0    -1  
$EndComp
Text Notes 8650 4600 1    79   ~ 0
WOOSH\nWOOSH
$Comp
L CP2 C?
U 1 1 550B51F3
P 4700 3900
F 0 "C?" V 4750 3750 40  0000 L CNN
F 1 "10u" V 4750 4000 40  0000 L CNN
F 2 "" H 4738 3750 30  0000 C CNN
F 3 "" H 4700 3900 60  0000 C CNN
	1    4700 3900
	0    1    -1   0   
$EndComp
$Comp
L C C?
U 1 1 550B5933
P 4950 3100
F 0 "C?" H 4950 3200 40  0000 L CNN
F 1 "1n" H 4956 3015 40  0000 L CNN
F 2 "" H 4988 2950 30  0000 C CNN
F 3 "" H 4950 3100 60  0000 C CNN
	1    4950 3100
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 550B5939
P 4700 3100
F 0 "C?" H 4700 3200 40  0000 L CNN
F 1 "100n" H 4706 3015 40  0000 L CNN
F 2 "" H 4738 2950 30  0000 C CNN
F 3 "" H 4700 3100 60  0000 C CNN
	1    4700 3100
	1    0    0    -1  
$EndComp
$Comp
L CP2 C?
U 1 1 550B593F
P 4450 3100
F 0 "C?" H 4450 3200 40  0000 L CNN
F 1 "1000u" H 4456 3015 40  0000 L CNN
F 2 "" H 4488 2950 30  0000 C CNN
F 3 "" H 4450 3100 60  0000 C CNN
	1    4450 3100
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 550B5FD3
P 6250 3100
F 0 "C?" H 6250 3200 40  0000 L CNN
F 1 "1n" H 6256 3015 40  0000 L CNN
F 2 "" H 6288 2950 30  0000 C CNN
F 3 "" H 6250 3100 60  0000 C CNN
	1    6250 3100
	1    0    0    -1  
$EndComp
$Comp
L C C?
U 1 1 550B5FD9
P 6000 3100
F 0 "C?" H 6000 3200 40  0000 L CNN
F 1 "100n" H 6006 3015 40  0000 L CNN
F 2 "" H 6038 2950 30  0000 C CNN
F 3 "" H 6000 3100 60  0000 C CNN
	1    6000 3100
	1    0    0    -1  
$EndComp
$Comp
L CP2 C?
U 1 1 550B5FDF
P 5750 3100
F 0 "C?" H 5750 3200 40  0000 L CNN
F 1 "1000u" H 5756 3015 40  0000 L CNN
F 2 "" H 5788 2950 30  0000 C CNN
F 3 "" H 5750 3100 60  0000 C CNN
	1    5750 3100
	1    0    0    -1  
$EndComp
$Comp
L R R?
U 1 1 550B7666
P 5550 4200
F 0 "R?" V 5450 4100 40  0000 C CNN
F 1 "10k" V 5557 4201 40  0000 C CNN
F 2 "" V 5480 4200 30  0000 C CNN
F 3 "" H 5550 4200 30  0000 C CNN
	1    5550 4200
	0    1    1    0   
$EndComp
$Comp
L C C?
U 1 1 550B7AEE
P 5900 4500
F 0 "C?" H 5900 4600 40  0000 L CNN
F 1 "2.2n" H 5906 4415 40  0000 L CNN
F 2 "" H 5938 4350 30  0000 C CNN
F 3 "" H 5900 4500 60  0000 C CNN
	1    5900 4500
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B7D1D
P 5900 4750
F 0 "#PWR?" H 5900 4500 60  0001 C CNN
F 1 "GND" H 5900 4600 60  0001 C CNN
F 2 "" H 5900 4750 60  0000 C CNN
F 3 "" H 5900 4750 60  0000 C CNN
	1    5900 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 3350 3650 3300
Wire Wire Line
	6750 4850 6750 4700
Wire Wire Line
	7750 4300 7850 4300
Wire Wire Line
	3400 3300 3400 3350
Wire Wire Line
	3150 3300 3150 3350
Wire Wire Line
	7850 4500 7700 4500
Wire Wire Line
	7700 4500 7700 4550
Wire Wire Line
	7150 4300 7350 4300
Wire Wire Line
	6550 4700 6550 4750
Wire Wire Line
	6150 5350 6100 5350
Wire Wire Line
	6650 4950 6650 4700
Wire Wire Line
	6650 5350 6750 5350
Wire Wire Line
	6750 5350 6750 5250
Wire Wire Line
	6400 4950 6400 5200
Wire Wire Line
	6100 4950 6650 4950
Wire Wire Line
	6100 5350 6100 4950
Connection ~ 6400 4950
Wire Wire Line
	7250 4400 7250 4300
Connection ~ 7250 4300
Wire Wire Line
	7250 4900 7250 4950
Wire Wire Line
	7250 5350 7250 5400
Wire Wire Line
	6150 4400 6100 4400
Wire Wire Line
	6100 4400 6100 4750
Wire Wire Line
	5050 4450 5050 4500
Wire Wire Line
	4400 4100 4500 4100
Wire Wire Line
	4500 4100 4500 4500
Wire Wire Line
	2750 3350 2750 2900
Wire Wire Line
	2750 2900 2650 2900
Wire Wire Line
	4900 3900 5050 3900
Wire Wire Line
	5050 3900 5050 3950
Wire Wire Line
	4950 3350 4950 3300
Wire Wire Line
	4700 3300 4700 3350
Wire Wire Line
	4450 3300 4450 3350
Wire Wire Line
	6250 3350 6250 3300
Wire Wire Line
	6000 3300 6000 3350
Wire Wire Line
	5750 3300 5750 3350
Wire Wire Line
	2650 2800 3800 2800
Wire Wire Line
	3150 2900 3150 2800
Connection ~ 3150 2800
Wire Wire Line
	3400 2900 3400 2800
Connection ~ 3400 2800
Wire Wire Line
	3650 2900 3650 2800
Connection ~ 3650 2800
Wire Wire Line
	4300 2800 5100 2800
Wire Wire Line
	5600 2800 6550 2800
Wire Wire Line
	6250 2900 6250 2800
Connection ~ 6250 2800
Wire Wire Line
	6000 2900 6000 2800
Connection ~ 6000 2800
Wire Wire Line
	5750 2900 5750 2800
Connection ~ 5750 2800
Wire Wire Line
	4950 2900 4950 2800
Connection ~ 4950 2800
Wire Wire Line
	4700 2900 4700 2800
Connection ~ 4700 2800
Wire Wire Line
	4450 2900 4450 2800
Connection ~ 4450 2800
Wire Wire Line
	6550 2800 6550 3900
Wire Wire Line
	5800 4200 6150 4200
Wire Wire Line
	5300 4200 5200 4200
Wire Wire Line
	5900 4300 5900 4200
Connection ~ 5900 4200
Wire Wire Line
	5900 4750 5900 4700
Wire Wire Line
	4500 3900 4400 3900
$Comp
L GND #PWR?
U 1 1 550B5FF1
P 6250 3350
F 0 "#PWR?" H 6250 3100 60  0001 C CNN
F 1 "GND" H 6250 3200 60  0001 C CNN
F 2 "" H 6250 3350 60  0000 C CNN
F 3 "" H 6250 3350 60  0000 C CNN
	1    6250 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B5FEB
P 6000 3350
F 0 "#PWR?" H 6000 3100 60  0001 C CNN
F 1 "GND" H 6000 3200 60  0001 C CNN
F 2 "" H 6000 3350 60  0000 C CNN
F 3 "" H 6000 3350 60  0000 C CNN
	1    6000 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B5FE5
P 5750 3350
F 0 "#PWR?" H 5750 3100 60  0001 C CNN
F 1 "GND" H 5750 3200 60  0001 C CNN
F 2 "" H 5750 3350 60  0000 C CNN
F 3 "" H 5750 3350 60  0000 C CNN
	1    5750 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B5951
P 4950 3350
F 0 "#PWR?" H 4950 3100 60  0001 C CNN
F 1 "GND" H 4950 3200 60  0001 C CNN
F 2 "" H 4950 3350 60  0000 C CNN
F 3 "" H 4950 3350 60  0000 C CNN
	1    4950 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B594B
P 4700 3350
F 0 "#PWR?" H 4700 3100 60  0001 C CNN
F 1 "GND" H 4700 3200 60  0001 C CNN
F 2 "" H 4700 3350 60  0000 C CNN
F 3 "" H 4700 3350 60  0000 C CNN
	1    4700 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 550B5945
P 4450 3350
F 0 "#PWR?" H 4450 3100 60  0001 C CNN
F 1 "GND" H 4450 3200 60  0001 C CNN
F 2 "" H 4450 3350 60  0000 C CNN
F 3 "" H 4450 3350 60  0000 C CNN
	1    4450 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5508AE30
P 3650 3350
F 0 "#PWR?" H 3650 3100 60  0001 C CNN
F 1 "GND" H 3650 3200 60  0001 C CNN
F 2 "" H 3650 3350 60  0000 C CNN
F 3 "" H 3650 3350 60  0000 C CNN
	1    3650 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5508AE1F
P 3400 3350
F 0 "#PWR?" H 3400 3100 60  0001 C CNN
F 1 "GND" H 3400 3200 60  0001 C CNN
F 2 "" H 3400 3350 60  0000 C CNN
F 3 "" H 3400 3350 60  0000 C CNN
	1    3400 3350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 5508AE0E
P 3150 3350
F 0 "#PWR?" H 3150 3100 60  0001 C CNN
F 1 "GND" H 3150 3200 60  0001 C CNN
F 2 "" H 3150 3350 60  0000 C CNN
F 3 "" H 3150 3350 60  0000 C CNN
	1    3150 3350
	1    0    0    -1  
$EndComp
$EndSCHEMATC
