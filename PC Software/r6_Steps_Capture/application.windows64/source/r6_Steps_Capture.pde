/* 
 * This file is part of the Rock6-Research distribution (https://github.com/cgxeiji/Rock6-Research).
 * Copyright (c) 2017 Eiji Onchi.
 * 
 * This program is free software: you can redistribute it and/or modify  
 * it under the terms of the GNU General Public License as published by  
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import processing.serial.*;
import ddf.minim.*;

Minim minim;
int counter = 0;
int counterDown = 0;

PlaySet playset;
AudioPlayer[] playlist;

String code;

int option = 0;

void setup() {
  //size(500, 500);
  fullScreen();
  
  initSerial();
  
  minim = new Minim(this);
  playset = new PlaySet(minim); // put the number here!!! > playset = new PlaySet(minim, 0);
  
  fill(255);
  textSize(200);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
}

long countdownTimer;

void draw() {
  background(0);
  if (startCountdown) {
    if (millis() - countdownTimer >= 500) {
      countdownTimer = millis();
      counterDown--;
    }
    if (counterDown != 0) {
      text(counterDown, width / 2, height / 2);  
    } else {
      startCountdown = false;
      switch(option) {
        case 0:
          thread("runPlaylist");
          break;
        case 1:
          thread("runTraining");
          break;
      }
    }
  } else {
    background(0);
  }
  
  if (running) {
    background(0, 0, 100);
    text("+", width / 2, height / 2);  
  }
}

boolean startCountdown = false;

void keyPressed() {
  if (!running) {
    if (key == ' ') {
      initTables();
      code = String.valueOf(year()) + String.valueOf(month()) + String.valueOf(day()) + String.valueOf(hour()) + String.valueOf(minute()) + String.valueOf(second());
      playlist = playset.getPlaylist();
      countdownTimer = millis();
      
      option = 0;
      counterDown = 5;
      startCountdown = true;
    } else if (key == 't') {
      playlist = playset.getTrainingPlaylist();
      countdownTimer = millis();
      
      option = 1;
      counterDown = 5;
      startCountdown = true;
    }
  }
  
  if (key == 'x') {
    
  }
}