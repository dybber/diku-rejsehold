// P_2_2_2_02.pde
// 
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * draw the path of an intelligent agent
 * 
 * MOUSE
 * position x          : drawing speed
 *
 * KEYS
 * 1-3                 : draw mode
 * Delete/Backspace    : clear display
 */


boolean recordPDF = false;


int NORTH = 0;
int EAST = 1;
int SOUTH = 2;
int WEST = 3;

float posX, posY;
float posXcross, posYcross;

int direction = SOUTH;
float angleCount = 7;    //// 1 - ...
float angle = getRandomAngle(direction);
float stepSize = 3;
int minLength = 10;

// width and brightness of the stroke depend on line length
int dWeight = 50;
int dStroke = 4;

int drawMode = 1;


void setup(){
  size(600, 600);
  colorMode(HSB, 360, 100, 100, 100);
  smooth();
  background(360);

  posX = int(random(0, width));
  posY = 5;
  posXcross = posX;
  posYcross = posY;
}


void draw(){
  for (int i=0; i<=mouseX; i++) {

    /* // ------ draw dot at current position ------ */
    /* if (!recordPDF) { */
    /*   strokeWeight(1); */
    /*   stroke(180); */
    /*   point(posX, posY); */
    /* } */

    // ------ make step ------
    posX += cos(radians(angle)) * stepSize;
    posY += sin(radians(angle)) * stepSize;

    // ------ check if agent is near one of the display borders ------
    boolean reachedBorder = false;

    if (posY <= 5) {
      direction = SOUTH;
      reachedBorder = true;
    } 
    else if (posX >= width-5) {
      direction = WEST;
      reachedBorder = true;
    }
    else if (posY >= height-5) {
      direction = NORTH;
      reachedBorder = true;
    }
    else if (posX <= 5) {
      direction = EAST;
      reachedBorder = true;
    }

    // ------ if agent is crossing his path or border was reached ------
    int px = (int) posX;
    int py = (int) posY;
    if (get(px, py) != color(360) || reachedBorder) {
      angle = getRandomAngle(direction);
      float distance = dist(posX, posY, posXcross, posYcross);
      if (distance >= minLength) {
        strokeWeight(distance/dWeight);
        if (drawMode == 1) stroke(0);
        if (drawMode == 2) stroke(52, 100, distance/dStroke);
        if (drawMode == 3) stroke(192, 100, 64, distance/dStroke);
        line(posX, posY, posXcross, posYcross);
      }
      posXcross = posX;
      posYcross = posY;
    }
  }
}

float getRandomAngle(int theDirection) {
  float a = (floor(random(-angleCount, angleCount)) + 0.5) * 90.0/angleCount;

  if (theDirection == NORTH) return (a - 90);
  if (theDirection == EAST) return (a);
  if (theDirection == SOUTH) return (a + 90);
  if (theDirection == WEST) return (a + 180);

  return 0;
}

void keyReleased(){
  if (key == DELETE || key == BACKSPACE) background(360);

  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key == '3') drawMode = 3;
}
