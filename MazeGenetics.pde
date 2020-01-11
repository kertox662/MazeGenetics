int[][] maze, dists;
boolean [][] visited, visitedFlood;

final int w = 30, h = 18;
final int padding = 50;
final int numSwap = 32;
final int numHoles = 75;

int cellWidth, cellHeight;

final int mazeStartX = 3, mazeStartY = 3;
final int mazeEndX   = w-3, mazeEndY = h-3;

int generationNumber = 1;
int maxFitness = 0;

ArrayList<Point> shortest;
int closest;

Population runPop;

/*
Directions:
1 is Up
2 is Right
4 is Down
8 is Left
*/

void setup(){
    size(1000,600);
    pixelDensity(displayDensity());
    maze = new int[h][w];
    dists = new int[h][w];
    visited = new boolean[h][w];
    visitedFlood = new boolean[h][w];
    pathVisited = new boolean[h][w];
    for(int i = 0; i < h; i++){
        for(int j = 0; j < w; j++){
            maze[i][j] = 15;
            //maze[i][j] = (byte)map(random(0,1), 0, 1, 0, 16);
        }
    }
    
    cellWidth = (width-padding)/w;
    cellHeight = (height-padding)/h;
    
    makeMaze();
    
    paths = new java.util.LinkedList<ArrayList<Point>>();
    floodQ = new java.util.LinkedList<FloodNode>();
    floodFill(mazeEndX, mazeEndY);
    
    shortest = shortestPath();
    closest = shortest.size();
    
    maxMoves = shortest.size() * 2;
    
    runPop = new Population();
    
    pushMatrix();
    translate((padding+width - cellWidth*(w+1))/2, (padding+height - cellHeight*(h+1))/2);
    background(255);
    strokeWeight(2);
    drawWalls();
    popMatrix();
}

void draw(){
    noStroke();
    fill(255);
    rect(0,0,width, padding/2 + 3);
    pushMatrix();
    translate((padding+width - cellWidth*(w+1))/2, (padding+height - cellHeight*(h+1))/2);
    
    //runPop.runners[runPop.currentRunner].eraseDisplay();
    //runPop.runners[runPop.currentRunner].display();
    for(Runner r : runPop.runners) r.eraseDisplay();
    runPop.simulateStep();
    drawPath();
    drawPoints();
    
    popMatrix();
    drawInfo();
}

void drawPath(){
    //stroke(255,0,255);
    noStroke();
    if(cellWidth >= 12){
        for(int i = 0; i < shortest.size(); i++){
            Point p = shortest.get(i);
            int b = (int)map(i,0,shortest.size(), 0,255);
            fill(100,b,b);
            rect(p.x * cellWidth + cellWidth/2-3, p.y*cellHeight+cellHeight/2-3, 6, 6);
        }
    } else{
        for(int i = 0; i < shortest.size(); i++){
            Point p = shortest.get(i);
            int b = (int)map(i,0,shortest.size(), 0,255);
            fill(100,b,b);
            rect(p.x * cellWidth + cellWidth/2-1, p.y*cellHeight+cellHeight/2-1, 2, 2);
        }
    }
}


void drawWalls(){
    strokeWeight(2);
    stroke(0);
    fill(0);
    
    for(int i = 0; i < h; i++){
        for(int j = 0; j < w; j++){
            int walls = maze[i][j];
            if((walls & 1) > 0){
                line(cellWidth * j, cellHeight*i, cellWidth*(j+1), cellHeight*i);
            }
            if((walls & 2) > 0){
                line(cellWidth * (j+1), cellHeight*i, cellWidth*(j+1), cellHeight*(i+1));
            }
            if((walls & 4) > 0){
                line(cellWidth * j, cellHeight*(i+1), cellWidth*(j+1), cellHeight*(i+1));
            }
            if((walls & 8) > 0){
                line(cellWidth * j, cellHeight*i, cellWidth*j, cellHeight*(i+1));
            }
        }
    }
}


void drawPoints(){
    noStroke();
    fill(255,0,0,120);
    rect(mazeStartX * cellWidth + 1, mazeStartY*cellHeight + 1, cellWidth - 2, cellHeight - 2);
    fill(0,255,0,120);
    rect(mazeEndX * cellWidth + 1, mazeEndY*cellHeight + 1, cellWidth - 2, cellHeight - 2);
}

void drawInfo(){
    fill(0);
    stroke(0);
    textSize(12);
    text("Generation:" + generationNumber, 10, 12);
    //text("Runner:" + (runPop.currentRunner+1), 10, 27);
    text("Max Fitness:" + maxFitness, 110, 12);
    text("Cur Move:" + runPop.currentMove, 110, 27);
    text("Shortest Path:" + shortest.size(), 210, 12);
    text("Closest Reached:" + closest, 210, 27);
}
