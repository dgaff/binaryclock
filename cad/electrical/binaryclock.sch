EESchema Schematic File Version 4
EELAYER 30 0
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
L Device:D_Bridge_+-AA D3-D6
U 1 1 608B1F19
P 2750 1550
F 0 "D3-D6" H 3094 1596 50  0000 L CNN
F 1 "Rectifier" H 3094 1505 50  0000 L CNN
F 2 "" H 2750 1550 50  0001 C CNN
F 3 "~" H 2750 1550 50  0001 C CNN
	1    2750 1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	2750 1100 1950 1100
$Comp
L pspice:DIODE D1
U 1 1 608BF290
P 1950 1850
F 0 "D1" V 1950 1722 50  0000 R CNN
F 1 "DIODE" V 1905 1722 50  0001 R CNN
F 2 "" H 1950 1850 50  0001 C CNN
F 3 "~" H 1950 1850 50  0001 C CNN
	1    1950 1850
	0    -1   -1   0   
$EndComp
Connection ~ 1950 2050
Wire Wire Line
	1950 2050 1550 2050
$Comp
L pspice:DIODE D2
U 1 1 608BABCD
P 1950 1300
F 0 "D2" V 1950 1428 50  0000 L CNN
F 1 "DIODE" V 1995 1428 50  0001 L CNN
F 2 "" H 1950 1300 50  0001 C CNN
F 3 "~" H 1950 1300 50  0001 C CNN
	1    1950 1300
	0    1    1    0   
$EndComp
Wire Wire Line
	1950 1500 1950 1550
Wire Wire Line
	1950 1100 1550 1100
Connection ~ 1950 1100
Wire Wire Line
	2750 1100 2750 1250
Wire Wire Line
	2750 1850 2750 2050
Wire Wire Line
	1950 2050 2750 2050
Wire Wire Line
	3050 1550 3550 1550
Wire Wire Line
	2450 1550 2450 2150
Wire Wire Line
	2450 2150 3550 2150
$Comp
L power:AC 9VAC
U 1 1 608C1E87
P 1550 1100
F 0 "9VAC" H 1550 1000 50  0001 C CNN
F 1 "AC" H 1655 1188 50  0000 L CNN
F 2 "" H 1550 1100 50  0001 C CNN
F 3 "" H 1550 1100 50  0001 C CNN
	1    1550 1100
	1    0    0    -1  
$EndComp
$Comp
L power:Earth #PWR?
U 1 1 608C39FB
P 1550 2050
F 0 "#PWR?" H 1550 1800 50  0001 C CNN
F 1 "Earth" H 1550 1900 50  0001 C CNN
F 2 "" H 1550 2050 50  0001 C CNN
F 3 "~" H 1550 2050 50  0001 C CNN
	1    1550 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 1550 1750 1550
Wire Wire Line
	1750 1550 1750 2450
Wire Wire Line
	1750 2450 2150 2450
Connection ~ 1950 1550
Wire Wire Line
	1950 1550 1950 1650
$Comp
L Device:R_Small_US R9
U 1 1 608C76A2
P 2250 2450
F 0 "R9" V 2455 2450 50  0000 C CNN
F 1 "22k" V 2364 2450 50  0000 C CNN
F 2 "" H 2250 2450 50  0001 C CNN
F 3 "~" H 2250 2450 50  0001 C CNN
	1    2250 2450
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_Small_US R10
U 1 1 608C7E9E
P 2400 2600
F 0 "R10" H 2468 2646 50  0000 L CNN
F 1 "2.2k" H 2468 2555 50  0000 L CNN
F 2 "" H 2400 2600 50  0001 C CNN
F 3 "~" H 2400 2600 50  0001 C CNN
	1    2400 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2350 2450 2400 2450
Wire Wire Line
	2400 2500 2400 2450
Connection ~ 2400 2450
Wire Wire Line
	2400 2450 3150 2450
$Comp
L power:GND #PWR?
U 1 1 608CEA6B
P 3550 2150
F 0 "#PWR?" H 3550 1900 50  0001 C CNN
F 1 "GND" H 3555 1977 50  0000 C CNN
F 2 "" H 3550 2150 50  0001 C CNN
F 3 "" H 3550 2150 50  0001 C CNN
	1    3550 2150
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 608CEEFD
P 2400 2700
F 0 "#PWR?" H 2400 2450 50  0001 C CNN
F 1 "GND" H 2405 2527 50  0000 C CNN
F 2 "" H 2400 2700 50  0001 C CNN
F 3 "" H 2400 2700 50  0001 C CNN
	1    2400 2700
	1    0    0    -1  
$EndComp
$Comp
L power:+VDC #PWR?
U 1 1 608CFD80
P 3550 1550
F 0 "#PWR?" H 3550 1450 50  0001 C CNN
F 1 "+VDC" H 3550 1825 50  0000 C CNN
F 2 "" H 3550 1550 50  0001 C CNN
F 3 "" H 3550 1550 50  0001 C CNN
	1    3550 1550
	1    0    0    -1  
$EndComp
Text Notes 3200 2550 0    50   ~ 0
Clock\nEnable
$Comp
L Transistor_BJT:BC337 Q?
U 1 1 608D46D9
P 5150 1450
F 0 "Q?" H 5341 1496 50  0001 L CNN
F 1 "BC337" H 5341 1450 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 5350 1375 50  0001 L CIN
F 3 "https://diotec.com/tl_files/diotec/files/pdf/datasheets/bc337.pdf" H 5150 1450 50  0001 L CNN
	1    5150 1450
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR?
U 1 1 608D61A0
P 5250 900
F 0 "#PWR?" H 5250 750 50  0001 C CNN
F 1 "+5V" H 5265 1073 50  0000 C CNN
F 2 "" H 5250 900 50  0001 C CNN
F 3 "" H 5250 900 50  0001 C CNN
	1    5250 900 
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small_US Rb
U 1 1 608D6C31
P 4750 1450
F 0 "Rb" V 4955 1450 50  0000 C CNN
F 1 "2.7k" V 4864 1450 50  0000 C CNN
F 2 "" H 4750 1450 50  0001 C CNN
F 3 "~" H 4750 1450 50  0001 C CNN
	1    4750 1450
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 608D74D6
P 5250 1800
F 0 "#PWR?" H 5250 1550 50  0001 C CNN
F 1 "GND" H 5255 1627 50  0000 C CNN
F 2 "" H 5250 1800 50  0001 C CNN
F 3 "" H 5250 1800 50  0001 C CNN
	1    5250 1800
	1    0    0    -1  
$EndComp
Text Notes 4350 1500 0    50   ~ 0
D3
Wire Notes Line style solid
	5400 950  5400 1150
Wire Notes Line style solid
	5100 1150 5100 950 
Text Notes 5150 1050 0    50   ~ 0
Clock
Wire Notes Line style solid
	5100 950  5400 950 
Wire Notes Line style solid
	5100 1150 5400 1150
Wire Wire Line
	5250 900  5250 950 
Wire Wire Line
	5250 1150 5250 1250
Wire Wire Line
	5250 1650 5250 1800
Wire Wire Line
	5200 1500 5200 1450
Wire Wire Line
	4850 1450 4950 1450
Wire Wire Line
	4650 1450 4500 1450
$EndSCHEMATC