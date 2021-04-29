#include "NTPClient.h"
#include "ESP8266WiFi.h"
#include "WiFiUdp.h"
#include "TimeLib.h"
#include "Timezone.h"
#include "GDBStub.h"

// Don't save your wifi to GitHub! Put these two declarations in your wifisecrets.h file and replace with your SSID and PW.
// const char *ssid     = "SSID";
// const char *password = "WIFI Password";
#include "wifisecrets.h"

// Wemos pin mapping
// #define A0 not sure  ADC0
// Digital pins can supply 12 mA max, so use transistor to switch higher current
#define D0 16 // WAKE
#define D1 5  // SCL
#define D2 4  // SDA
#define D3 0  // FLASH
#define D4 2  // Blue LED - lights on digital 0
#define D5 14 // SCLK
#define D6 12 // MISO
#define D7 13 // MOSI
#define D8 15 // CS
#define TX 1  // TX
#define RX 3  // RX

// Timezone rules and initialization
TimeChangeRule usEDT = {"EDT", Second, Sun, Mar, 2, -240};  //UTC - 4 hours
TimeChangeRule usEST = {"EST", First, Sun, Nov, 2, -300};   //UTC - 5 hours
Timezone usEastern(usEDT, usEST);

// Turn on serial output for debugging
#define SERIAL

// Time info. I'm using timezone library to convert, so no UTC offset required.
//const long utcOffsetInSeconds = -18000; // EST
//const long utcOffsetInSeconds = -14400; // EDT
const long utcOffsetInSeconds = 0; // UTC

// Define NTP Client to get time
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP, "north-america.pool.ntp.org", utcOffsetInSeconds);

// VT100 Terminal Emulation - helpful for serial debug output
#define OFF         "\033[0m"
#define BOLD        "\033[1m"
#define LOWINTENS   "\033[2m"
#define UNDERLINE   "\033[4m"
#define BLINK       "\033[5m"
#define REVERSE     "\033[7m"
#define GOTOXY( x,y) "\033[x;yH"   // Esc[Line;ColumnH  <-- this doesn't seem to be expanding correclty
#define CLS          "\033[2J"

// Clock mode
bool clock24hrMode = true;

// Power cycle the clock. In addition to powering the clock circuit, there is an enable pin on the PIC16.
//
// D1 is HR
// D2 is MIN
// D3 is clock power through transistor
// D4 is clock enable - puts Pin 4 on the PIC16 low, which is required to light up the clock
// D8 is DIM switch through transistor

void restartClock()
{
    // Turn off clock 
    digitalWrite(D3, LOW);
    digitalWrite(D4, HIGH);
    delay(500);

    // Hold HR low for 24-hour mode
    if (clock24hrMode) 
    {
      digitalWrite(D1, LOW);
      delay(100);
    }

    // Turn on clock - this puts it in setup mode, so seconds are not counting yet
    digitalWrite(D3, HIGH);
    delay(100); 
    digitalWrite(D4, LOW);
    delay(100); 

    // Release HR for 24-hour mode
    if (clock24hrMode)
    { 
      digitalWrite(D1, HIGH);
      delay(100);
    } 

    // Extra startup time
    delay(200); 

    // Click Dim twice to get to brightest setting. Clock seems to start on med, but not consistently.
    digitalWrite(D8, HIGH);
    delay(50);
    digitalWrite(D8, LOW);
    delay(100);
    digitalWrite(D8, HIGH);
    delay(50);
    digitalWrite(D8, LOW);
    delay(100);
}

// Set the clock time. This should be called when seconds hit :00 and you should call restartClock() a few seconds before this.
// Clock starts at 12:01 since we used MIN line to start the second hand after restarting the clock.

void setClockTime(int hour, int minute)
{
    int hr = hour;
    int hrcount = 12;
    int min = minute;
    int mincount = 1;

    // Click MIN - this starts the second counter. Time is now 12:01:00 on the clock.
    digitalWrite(D2, LOW);
    delay(100); // hold this for a bit longer
    digitalWrite(D2, HIGH);
    delay(500);

    // Handle wrap-around case when the clock has started past the current time.
    if (hr < 12) hr = hr + 24;
    if (min < 1) min = min + 60;

    // Advance the hour
    while (hrcount < hr) 
    {
      digitalWrite(D1, LOW);
      delay(50);
      digitalWrite(D1, HIGH);
      delay(50);
      hrcount++;
    }

    // Advance the minute
    while (mincount < min)
    {
      digitalWrite(D2, LOW);
      delay(50);
      digitalWrite(D2, HIGH);
      delay(50);
      mincount++;
    }
}

// Run once setup - sets up the initial output pin states and gets on wifi

void setup()
{
  // Serial port output. Note that GDB isn't working reliably yet.
#ifdef SERIAL  
  Serial.begin(115200);
//  gdbstub_init();
#endif

  // Set all pins to digital output
  pinMode(D0, OUTPUT); 
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D3, OUTPUT);
  pinMode(D4, OUTPUT);
  pinMode(D5, OUTPUT);
  pinMode(D6, OUTPUT);
  pinMode(D7, OUTPUT);
  pinMode(D8, OUTPUT);

  // HR/MIN/DIM buttons unpressed. Restart the clock so you can see it light up. 
  digitalWrite(D1, HIGH);
  digitalWrite(D2, HIGH);
  digitalWrite(D3, LOW);
  digitalWrite(D4, HIGH);
  digitalWrite(D8, LOW);
  restartClock();

  // Connect to Wifi
  WiFi.begin(ssid, password);
  while ( WiFi.status() != WL_CONNECTED ) {
    delay ( 500 );
  }

  // Initialize NTP time
  timeClient.begin();
}

// Main Loop - primary job is to set the clock time once and watch for DST changes. May add clock drift support at some point.

int initClockTime = 1; // 1 = power cycle the clock at :55   2 = synchronize seconds and set the time at :00
bool isDST = false;    // used to catch DST change, not yet tested

void loop()
{
  // Read the UTC time
  timeClient.update();
  time_t timeUTC = timeClient.getEpochTime();

  // Convert to EST or EDT
  time_t time = usEastern.toLocal(timeUTC);

  // Macros to calculate local time
  int hour = numberOfHours(time);
  int minute = numberOfMinutes(time);
  int seconds = numberOfSeconds(time);

  // Do we need to set the LED clock? 
  if (initClockTime)
  {
    // Power cycle the clock ahead of second syncronization, since this takes a few hundred ms
    if (initClockTime == 1 && seconds == 55)
    {
      restartClock();
      initClockTime++;
    }
    // Wait for seconds to roll around to zero. This will sync to NTP time, at least as close as we can get.
    else if (initClockTime == 2 && seconds == 0)
    {
#ifdef SERIAL
      char timestr[10];
//  Serial.print("\033[0;0H"); // terminal emulation to go to top
//  sprintf(timestr, "%02d:%02d:%02d", timeClient.getHours(), timeClient.getMinutes(), timeClient.getSeconds());
      sprintf(timestr, "%02d:%02d:%02d", hour, minute, seconds);
      Serial.println(timestr);
#endif  

      delay(600); // trial and error to get seconds synced 
      setClockTime(hour, minute);
      isDST = usEastern.locIsDST(time);
      initClockTime = 0;
    }
  }
  // Only check for DST or drift after clock is set.
  else
  {
    // Check for DST change once the clock has been initialized. isDST variable was set on the first initClockTime.
    if (isDST != usEastern.locIsDST(time)) initClockTime = 1;

    // Check for drift correction
    /*
      Need to watch the clock for a while and see how much it drifts. Then just periodically init the clock again.
      If the LED clock is put on a Hue timer or something to have it off at night, this isn't really necessary.  
    */
  }

  yield();
}
