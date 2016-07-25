//Must be contained in a folder with same name for setup and draw to function
//Other files in this folder are appended on build
PVector pos;
PVector vel;
final float r = 50;
void setup(){
  size(300,300);
  pos = new PVector(random(width-r*2)+r,random(height-r*2)+r);
  vel = new PVector(random(3,5)*(int)random(0,1)*2-1,random(3,5)*(int)random(0,1)*2-1);
}
void draw(){
  clear();
  background(255);
  fill(100,100,100);
  if(pos.x+vel.x+r > width || pos.x+vel.x-r < 0) vel.x *= -1;
  if(pos.y+vel.y+r > height || pos.y+vel.y-r < 0) vel.y *= -1;
  pos.add(vel);
  ellipse(pos.x,pos.y,r*2,r*2);
}
