/**
 * This class represents a node in the graph
 */
class Node {
  
  //Constant declarations
  static final color nodeColor   = #F0C070;
  final color selectedColor = color(150, 10, 15);
  
  //Variable declarations
  float x, y;
  String label;
  int edgeCount; // the degree of the node, i.e. the number of connecting edges
  float force_x, force_y;
  boolean over;
  boolean adjusted = false;

  //Constructor using the node label name as a parameter
  Node(String label) {
    this.label = label;
    x = random(width);
    y = random(height);
  }
  
  //Counter method for use outside of class
  void increment() {
    edgeCount++;
  }
  

  //Method to draw the nodes of the visualization will be called in network class and drawn frame by frame
  void draw() {
    
    if(over){ //change fill color if mouse is over the ellipse
      fill(selectedColor);
    }else{
      fill(nodeColor);
    }
    stroke(0);
    strokeWeight(0.5);
    ellipse(x, y, edgeCount, edgeCount); // Nodes with more edges are drawn larger
    
    float w = textWidth(label);

    // Draw the label if it will fit inside the ellipse and update label color if selected
    if (edgeCount > w+2) {
      fill(0);
      textAlign(CENTER, CENTER);
      text(label, x, y);
    }else if(over){
      fill(selectedColor);
      textAlign(CENTER, CENTER);
      text(label, x, y-edgeCount);
    }
  }
  
  
  //Changes position of node to mouse dragged position using mouse x and y positions as arguments
  void adjustPos(float mX, float mY){ 
    adjusted = true;
    x = mX;
    y = mY;
  }
  
  
  //Determines whether mouse is over a node using mouse x and y positions as arguments
  void rollOver(int mPosX, int mPosY){
      //use vector to get more accurate node check 
      float dx =  mPosX - x;
      float dy = mPosY - y;
      
      if((dx*dx + dy*dy) <= edgeCount*edgeCount){
        over = true;
      }else{
        over = false;
      }
  }
  
  
  //GETTER METHODS
  //Return boolean for mouse over
  boolean getOver(){
    return over;
  }
  
  // Return boolean for graph adjustment
  boolean getAdjusted(){
    return adjusted;
  }
}

  
  