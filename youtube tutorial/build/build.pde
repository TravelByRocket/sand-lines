//**********************************************************************
// Program name      : .pde
// Author            : Bryan Costanza (GitHub: TravelByRocket)
// Date created      : 20191201
// Purpose           : 
//**********************************************************************

int anchorCount;

void settings() {
  size(600,600);
}

void setup() {
  anchorCount = 20;
  createSaveString();

	background(255);
}


void draw() {
	noStroke();
	fill(255,10);
	rect(0, 0, width, height);

	float[] anchorX = new float[anchorCount];
	float[] anchorY = new float[anchorCount];

	float noiseScale = 0.01;
	float controlRadius = 10;

	float[] angleNoiseValue = new float[anchorCount];
	float[] controlAngleDeg = new float[anchorCount];

	float[] controlLeftX = new float[anchorCount];
	float[] controlLeftY = new float[anchorCount];
	float[] controlRightX = new float[anchorCount];
	float[] controlRightY = new float[anchorCount];

	for (int i = 0; i < anchorCount; ++i) {
		anchorX[i] = map(i, 0, anchorCount, width/10, width*9/10);

		float heightNoiseValue = noise(0, frameCount * noiseScale + i);
		anchorY[i] = map(heightNoiseValue, 0, 1, height/4, height*3/4);

		angleNoiseValue[i] = noise(frameCount * noiseScale + i);
		controlAngleDeg[i] = map(angleNoiseValue[i], 0, 1, -60, 60);

		controlLeftX[i] = anchorX[i] - controlRadius * cos(radians(controlAngleDeg[i]));
		controlLeftY[i] = anchorY[i] - controlRadius * sin(radians(controlAngleDeg[i]));
		controlRightX[i] = anchorX[i] + controlRadius * cos(radians(controlAngleDeg[i]));
		controlRightY[i] = anchorY[i] + controlRadius * sin(radians(controlAngleDeg[i]));

		// noStroke();
		// fill(225);
		// circle(anchorX[i],anchorY[i],5);
		// circle(controlLeftX[i],controlLeftY[i],5);
		// circle(controlRightX[i],controlRightY[i],5);
		// stroke(225);
		// line(anchorX[i], anchorY[i], controlLeftX[i], controlLeftY[i]);
		// line(anchorX[i], anchorY[i], controlRightX[i], controlRightY[i]);
	}

	for (int j = 0; j < anchorCount - 1; ++j) {
		noFill();
		strokeWeight(1);
		stroke(#38a6c2);
		bezier(anchorX[j], anchorY[j], 
					 controlRightX[j], controlRightY[j], 
					 controlLeftX[j+1], controlLeftY[j+1], 
					 anchorX[j+1], anchorY[j+1]);
	}

	saveScreenshot();  
}

void saveScreenshot(){
	save(folderName + "/capture" + nf(frameCount,4) + ".png");
}

String folderName;
void createSaveString(){
	String dateTimeCode = year() +
								 nf(month(),2) + 
								 nf(day(),2) + 
								 nf(hour(),2) + 
								 nf(minute(),2) + 
								 nf(second(),2);
	folderName = "screenshots" + dateTimeCode;
}