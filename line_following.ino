#include <Adafruit_MotorShield.h>
#include <Wire.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Adafruit_MotorShield AFMS = Adafruit_MotorShield();
Adafruit_DCMotor *myMotor1 = AFMS.getMotor(1);
Adafruit_DCMotor *myMotor2 = AFMS.getMotor(2);
const int l_sensor =A0; //left sensor
const int r_sensor =A1; //right sensor
const int pot = A2;
int newSpeed;
int potRead;
String initMessage;
String state;
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void setup() {
    AFMS.begin();
    //speed range from 0 to 255
    myMotor1->setSpeed(30);
    myMotor2->setSpeed(30);
    pinMode(l_sensor, INPUT);
    pinMode(r_sensor, INPUT);
    pinMode(pot, INPUT);
    Serial.begin(9600);
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
void loop() {
    int left=0;
    int right=0;
    int threshold = 150;
    int turn_delay=2;
    left=analogRead(l_sensor);
    right=analogRead(r_sensor);
    potRead=analogRead(pot);
    newSpeed = (70 * potRead/1023) + 30; //Change the behavior while driving by using the potentiometer
    myMotor1->setSpeed(newSpeed);
    myMotor2->setSpeed(newSpeed);
    // motor1 left, motor2 right

     // Check for serial input to adjust motor speeds
    if(Serial.available()>0){
      newSpeed = Serial.read();
      myMotor1->setSpeed(newSpeed);
      myMotor2->setSpeed(newSpeed);
      Serial.println("New motor speed is "+String(newSpeed)+" RPM");
    }

    // Note, when the motors are sent a "BACKWARD" request, we are asking the robot to move forward, since the motors are mounted "backwards" on our robot.
    if(left>threshold){
        myMotor1->run(RELEASE);
        myMotor2->run(BACKWARD);
        // Data format is [leftMotorSpeed, rightMotorSpeed, leftSensorReading, rightSensorReading]
        state = "[0, 30, "+String(left)+", "+String(right)+"]";
        Serial.println(state);
        }else if (right>threshold){
        myMotor1->run(BACKWARD);
        myMotor2->run(RELEASE);
        // Data format is [leftMotorSpeed, rightMotorSpeed, leftSensorReading, rightSensorReading]
        state = "[30, 0, "+String(left)+", "+String(right)+"]";
        Serial.println(state);
    }
}
