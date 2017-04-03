// Configuration variables
int numBrickRows = 10;
int brickWidth = 50;
int brickHeight = 20;
int paddleHeight = brickHeight;
int paddleWidth = int(brickWidth*1.5);
int ballDiameter = 10;

// global variables
Brick[] bricks = new Brick[0];
Paddle myPaddle;
Ball myBall;



/** setup function
 */
void setup() {
  size(400,400);
  smooth();  
  // place bricks
  for (int j=0; j < numBrickRows; j++) { // rows
    // location of each row  
    int y = brickHeight / 2 + j * brickHeight;
    // set the row offset
    int offset = 0;
    if (j % 2 == 0) {
      offset = brickWidth / 2;
    }
    // draw the row
    for (int i=offset; i < width+brickWidth/2.0; i += brickWidth) { // columns
      bricks = (Brick[]) append(bricks, new Brick(i,y));
    }
  }
  
  
  // create paddle
  myPaddle = new Paddle();
  
}


/** Standard draw() function 
 */
void draw() {
  background(255);
  

  
  // draw bricks
  for (int i=0; i < bricks.length; i++) {
    if (bricks[i] != null) {
      bricks[i].draw();
    }
  }
 
  // draw and update ball
  if (myBall != null) {
    myBall.draw();
    myBall.update();
  }
 
  // draw paddle
  myPaddle.display();
  
 
  // test for ball impact with paddle
  if (myBall != null && myPaddle.impact(myBall)) {
    // bounce ball 
    myBall.bounce();
    // impart x velocity from paddle
    myPaddle.impartXVelocity(myBall);
  }
  
  // test for ball impact with brick
  if (myBall != null) {
    for (int i=0; i < bricks.length; i++) {
      if (bricks[i] != null && bricks[i].impact(myBall) == true) {
        // bounce ball
        myBall.bounce();
        // delete brick
        bricks[i] = null;
      }
    }
  }
  
  // bounce ball if above screen
  if (myBall != null && myBall.yPosition-ballDiameter/2 < 0) {
    myBall.bounce();
  }
  
  // enable new ball if ball is lost
  if (myBall != null && myBall.yPosition-ballDiameter/2 > height) {
    myBall = null;
  }
  
  // test and see if we've won!
  boolean weHaveWon = true;
  for (int i=0; i < bricks.length; i++) {
    if (bricks[i] != null) {
      weHaveWon = false;
      break;
    }
  }
  if (weHaveWon) {
    println("YOU'VE WON!!!");
    exit();
  }
}


/** MouseClicked function, which fires a new ball */
void mouseClicked() {
    // create ball
    if (myBall == null) {
      myBall = new Ball(myPaddle.xPos, height - paddleHeight - ballDiameter/2, 0, -2);
    }
}



//////////////////////////////////////////

/** The ball for the BrickBreaker game
 */
class Ball {
  
  int xPosition;
  int yPosition;
  int xSpeed;
  int ySpeed;
  
  /** Constructor
   * x - the initial x position
   * y - the initial y position
   * xInitialSpeed - the initial speed in the x direction
   * yInitialSpeed - the initial speed in the y direction
   */
  Ball(int x, int y, int xInitialSpeed, int yInitialSpeed) {
    xPosition = x;
    yPosition = y;
    xSpeed = xInitialSpeed;
    ySpeed = yInitialSpeed;
  }  
  
  /** draws the ball */
  void draw() {
    fill(0);
    ellipse(xPosition, yPosition, ballDiameter, ballDiameter);
  }
  
  /** Updates the position of the ball, including bounces off of verticals */
  void update() {
    // update position
    xPosition += xSpeed;
    yPosition += ySpeed;
    // bounce off of verticals
    if (xPosition < 0 || xPosition > width) {
      xSpeed *= -1;
    }
  }
  
  /** Bounce the ball off of horizontals */
  void bounce() {
    ySpeed *= -1;
  }
}



//////////////////////////////////////////


/** Represents a brick in the game */
class Brick {
  int xPosition;
  int yPosition;
  color c;
  
  /** Constructor
   * x - the x position of the brick
   * y - the y position of the brick
   */
  Brick(int x, int y) {
    xPosition = x;
    yPosition = y;
    c = color(random(255), random(255), random(255));
  }
  
  /** Draws the brick */
  void draw() {
    rectMode(CENTER);
    fill(c);
    rect(xPosition, yPosition, brickWidth, brickHeight);
  }
  
  /** Detects whether the ball b impacted the brick
   * b - the ball to test
   * returns true if there was an impact, false otherwise
   */
  boolean impact(Ball b) {
    if (xPosition - brickWidth/2 <= b.xPosition &&
        b.xPosition <= xPosition + brickWidth/2 &&
        yPosition + brickHeight/2 > b.yPosition-ballDiameter/2)
        return true;
    else
        return false;
  }
}


//////////////////////////////////////////


/** Represents the paddle in the game */
class Paddle {
  
  int xPos = mouseX;
  int yPos = height - paddleHeight/2;
  
  int xPosPrevious;
 
  /** Displays the paddle */
  void display() {
    fill(0);
    xPosPrevious = xPos;
    xPos = mouseX;
    rect(xPos, yPos, paddleWidth, paddleHeight);
  }
  
  /** Detects whether the ball impacted the paddle
   * b - the ball to test for impact
   * returns whether there was an impact or not 
   */
  boolean impact(Ball b) {
    if (xPos - paddleWidth/2 <= b.xPosition &&
        b.xPosition <= xPos + paddleWidth/2 &&
        yPos - paddleHeight/2 < b.yPosition+ballDiameter/2)
        return true;
    else
        return false;
  }
  
  /** Imparts the x velocity of the paddle to the ball
   * b - the ball
   */
  void impartXVelocity(Ball b) {
    int xVector = xPos - xPosPrevious;
    b.xSpeed += xVector;
  }

}