/*
Force directed network visualization of storm of swords character relationships.
Created by Matt Bonazzoli as part of COMP494 Data Visualization class
Data provided by Andrew Beveridge
*/


// Constant declaration
static final String filepath = "stormofswords.csv";
static final float MAX_DISPLACEMENT_SQUARED = 100;

//Variable declaration
Node[] nodes;
Edge[] edges;

HashMap<String, Node> nodeNames = new HashMap<String, Node>();

int edgeCount;
int nodeCount;

PFont font;


// Method that sets up the visualization window, loads data, and initializes variables
void setup() {
  size(2000, 1500);
  pixelDensity(displayDensity());

  edgeCount = 0;
  nodeCount = 0;

  font = createFont("SansSerif", 10);
  textFont(font);

  loadData();
}


//Method that loads in all of the data using global filepath
void loadData() {
  Table table = loadTable(filepath, "header");

  //Determine the number of unique nodes, i.e. characters in Game of Thrones
  //There might be unique characters in either column so they need to be combined and then the disticnt ones can be figured out.
  
  String[] sourceNodes = table.getUnique("Source");
  String[] targetNodes = table.getUnique("Target");
  String[] combined = new String[sourceNodes.length + targetNodes.length];
  
  System.arraycopy(sourceNodes, 0, combined, 0, sourceNodes.length);
  System.arraycopy(targetNodes, 0, combined, sourceNodes.length, targetNodes.length);
  
  StringList combinedList = new StringList(combined);
  String[] uniqueNodeNames = combinedList.getUnique();

  nodes = new Node[uniqueNodeNames.length];
  
  //Creating a node for each character label.
  for (int i = 0; i<nodes.length; i++){
    nodes[i] = new Node(uniqueNodeNames[i]);
    nodeNames.put(uniqueNodeNames[i], nodes[i]);
    nodeCount++;
  }
  
  //Creating the edges between each nodes
  edges = new Edge[table.getRowCount()];
  for (int i = 0; i<table.getRowCount(); i++) {
    TableRow row = table.getRow(i);
    String from = row.getString("Source");
    String to = row.getString("Target");
    float weight = row.getFloat("Weight");
    
    //Find the nodes that correspond with source and target and add an edge from one to the other
    edges[i] = new Edge(nodeNames.get(from), nodeNames.get(to), weight);
    nodeNames.get(from).edgeCount++;
    nodeNames.get(to).edgeCount++;
    edgeCount++;
  }
}


/*
Using node positions and edge realtionships calculates force vectors 
between nodes every frame to adjust the node positions in the network.
*/
void updatePositions(){
  //Updating the node positions using a force-directed layout
  float L = 100;
  float K_r = 6250;
  float K_s = 1;
  float delta_t = 0.04;
  
  //Initializing net forces
  for (Node n:nodes){
    n.force_x = 0;
    n.force_y = 0;  
  }
  //Calculating repulsion force vectors btw all pairs of nodes
  for (int i = 0; i<nodes.length-1;i++){
    Node node1 = nodes[i];
    for (int j = 0; i<nodes.length-2;i++){
    Node node2 = nodes[j];
    
    float dx = node2.x - node1.x;
    float dy = node2.y - node1.y;
    
      if (dx != 0 || dy != 0){
        float distanceSquared = dx*dx + dy*dy;
        float distance = sqrt(distanceSquared);
        float force = K_r/distanceSquared;
        
        float fx = force * dx/distance;
        float fy = force * dy/distance;
        
        node1.force_x -= fx;
        node1.force_y -= fy;
        node2.force_x += fx;
        node2.force_y += fy;
      
      }
    }
  }
  
  //Calculating spring force vectors between all adjacent pairs
  for(Edge e: edges){
    Node node1 = e.from;
    Node node2 = e.to;
    
    float dx = node2.x - node1.x;
    float dy = node2.y - node1.y;
    
    if (dx != 0 || dy != 0){
      float distance = sqrt(dx*dx + dy*dy);
      float force = K_s * (distance - L);
      float fx = force * dx/distance;
      float fy = force * dy/distance;
      node1.force_x += fx;
      node1.force_y += fy;
      node2.force_x -= fx;
      node2.force_y -= fy; 
    }
  }
    
  //update node position using the spring force vectors and repulsion vectors 
  for (int i = 0;i<nodes.length;i++){
    Node node = nodes[i];
    if(node.getAdjusted()==false){
      float dx = delta_t * node.force_x;
      float dy = delta_t * node.force_y;
      
      float displacementSquared = dx*dx + dy*dy;
      if (displacementSquared > MAX_DISPLACEMENT_SQUARED){
        float s = sqrt(MAX_DISPLACEMENT_SQUARED/ displacementSquared);
        dx *= s;
        dy *= s;
      }
      node.x += dx;
      node.y += dy;
    }
  }
}
   

//Method that draws the nodes and edges of the network
void draw() {
  //Draw the network and have the node relationships continuously update
  background(255);
  updatePositions();
  for (Edge edge : edges) {
    edge.draw();
  }

  for (Node node : nodes) {
    node.draw();
  }
}


//Event handler for mouse movement
void mouseMoved(){
  //On mouse rollover display name of node in network
  for(Node n:nodes){
    n.rollOver(mouseX, mouseY);
  }
}


//Event handler for mouse dragging
void mouseDragged(){
  //On mouse drag move node to new position and update network repulsion and attraction forces
  for(Node n: nodes){
    if(n.getOver()){
      n.adjustPos(mouseX, mouseY);
    }
  }
}