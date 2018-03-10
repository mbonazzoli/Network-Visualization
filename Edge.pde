/**
 * This class represents an edge in the graph
 */
class Edge {
  
  // Constant declaration
  static final color edgeColor   = #000000;
  
  //Variable declaration
  Node from;
  Node to;
  float weight;
  

  //Constructor using the two connecting nodes and the weight between them as parameters
  Edge(Node from, Node to, float weight) {
    this.from = from;
    this.to = to;
    this.weight = weight;
  }
  

  //Method to draw the edges of the visualization in the netowrk class. Will be drawn frame by frame
  void draw() {
    stroke(edgeColor);
    strokeWeight(0.35);
    line(from.x, from.y, to.x, to.y);
  }
}