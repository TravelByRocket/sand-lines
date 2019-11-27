// In progress. Updating notation for an arbitrary number of anchor points.

// Bryan Costanza
// Processing 3
// inspired by, and typo, of https://github.com/inconvergent/sand-spline

int pointCount = 25; // number of anchor points for the bezier curves, spaced evenly across the x axis
int n = 1000; // number of iterations

float noiseScale = 0.005; // smaller for closer correlation of motion, larger for no correlation. ... 
// Where 0.001 seemingly draws hills with waves, 0.005 draws topographical maps of mountains, 0.01 is almost completely uncorrelated
float motionScale = 700; // vertical travel distance

float armLengthMin = 5; // larger values for smoother transitions at anchor points
float armLengthMax = 15; // larger values may lead to overlap, especially with many anchor points. Can get trippy when larger than width/pointCoint*10

float anchorPoints[][] = new float[pointCount][pointCount]; // bezier curve anchor points
float controlPointsL[][] = new float[pointCount][pointCount]; // left-side control points for bezier curves
float controlPointsR[][] = new float[pointCount][pointCount]; // right-side control points for bezier curves
float armLengthL[] = new float[pointCount]; // line running through the anchor points that the control points must sit on 
float armLengthR[] = new float[pointCount]; // same as above
float controlAngles[] = new float[pointCount]; // angle of the "arms" that run through the anchor points

int counter = 0; // don't change this; used to stop at the desited number of iterations

String infoText;

// every bezier has two anchors and two control points
// every anchor will have an angle going through it that control the anchors connected to it
// there are n anchor points and n control points
// it goes a0,c0,c1l,a1 repeating again as a1,c1r,c2l,a2    where c1 and c2 

void setup() {
  size(600, 600);
  background(#FFFFFF);
  textSize(18);
  for (int i = 0; i < pointCount; i++) {
    anchorPoints[i][0] = width*(i+1)/(pointCount+1);
    anchorPoints[i][1] = height/2;
  }
  infoText = width+"x"+height+"|noiseScale="+noiseScale+"|motionScale="+str(int(motionScale))+
  "|pointCount="+str(pointCount)+"|arm min/max="+str(int(armLengthMin))+"/"+str(int(armLengthMax));
}

void draw() {
  fill(255, 255, 255, 5); // (very) transparent white
  rect(0, 0, width, height); // draw rectangles across the canvas for a fading effect
  noFill(); // don't fill the bezier curve space
  stroke(#0C7489); // electric seaweed
  fill(#0C7489);
  //text(infoText, 0, 20);
  noFill();

  for (int j = 0; j < pointCount; j++) { // update every point (j) on each iteration (counter)
    controlAngles[j] = map(noise(anchorPoints[j][0]*noiseScale, counter*noiseScale), 0, 1, -HALF_PI/2, HALF_PI/2); // "travel" through y for noise 
    anchorPoints[j][1] = map(noise(anchorPoints[j][0]*noiseScale, 0, counter*noiseScale), 0, 1, height/2 - (motionScale/2), height/2 + (motionScale/2)); // "travel" through z
    armLengthL[j] = map(noise(j*noiseScale, counter*noiseScale), 0, 1, armLengthMin, armLengthMax); // "travel" through y
    armLengthR[j] = map(noise(counter*noiseScale, j*noiseScale), 0, 1, armLengthMin, armLengthMax); // "travel" through x
    controlPointsL[j][0] = anchorPoints[j][0] - armLengthL[j]*cos(controlAngles[j]); // offset left control points along the control arm in the x direction
    controlPointsL[j][1] = anchorPoints[j][1] + armLengthL[j]*sin(controlAngles[j]); // offset left control points along the control arm in the y direction
    controlPointsR[j][0] = anchorPoints[j][0] + armLengthR[j]*cos(controlAngles[j]); // offset right control points along the control arm in the x direction
    controlPointsR[j][1] = anchorPoints[j][1] - armLengthR[j]*sin(controlAngles[j]); // offset right control points along the control arm in the y direction
  }
  
  beginShape();
  vertex(anchorPoints[0][0], anchorPoints[0][1]); // first anchor point
  for (int i = 0; i < pointCount-1; i++) { //once for each segment, which is 1 less than the number of points
    bezierVertex(
      controlPointsR[i][0], controlPointsR[i][1], // right-side control point for previous anchor point
      controlPointsL[i+1][0], controlPointsL[i+1][1], // left-side control point for next anchor point
      anchorPoints[i+1][0], anchorPoints[i+1][1]); // the next anchor point
  }
  endShape();

  //enable the k for loop to see control points and arms animated
  //for (int k = 0; k < pointCount; k++) {
  //line(controlPointsR[k][0], controlPointsR[k][1], anchorPoints[k][0], anchorPoints[k][1]);
  //line(controlPointsL[k][0], controlPointsL[k][1], anchorPoints[k][0], anchorPoints[k][1]);
  //ellipse(controlPointsR[k][0], controlPointsR[k][1], 3, 3); // right-side control point for previous anchor point
  //ellipse(controlPointsL[k][0], controlPointsL[k][1], 3, 3); // left-side control point for next anchor point
  //ellipse(anchorPoints[k][0], anchorPoints[k][1], 5*k, 3); // the next anchor point
  //}
  saveFrame("makevid/frame####.png");


  if (counter == n) {
    noLoop(); // stop the animation after doing the required number of iterations
    //String r = nf(random(1000),4,0);
    String y = str(year());
    String m = nf(month(),2,0);
    String d = nf(day(),2,0);
    String s = nf(second(),2,0);
    String filename = y+m+d+s+".png";
    save("screenshots/"+filename);
  }
  counter++;
}
