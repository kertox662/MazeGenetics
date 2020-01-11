final int[][] moves = {{-1,0},{0,1},{1,0},{0,-1}};
final int maxHistory = 20;
final int maxRepeat = 3;
final int closenessBias = 4;
final int difBias = 6;

private class Runner{
    DNA genes;
    Point pos, prev;
    int numMoves;
    int fitness;
    boolean finished;
    int closestSoFar;
    int closeMove;
    
    Runner(){
        genes = new DNA();
        pos = new Point(mazeStartX, mazeStartY);
        prev = new Point(mazeStartX, mazeStartY);
        numMoves = 0;
        finished = false;
        closestSoFar = shortest.size();
        closeMove = 0;
    }
    
    Runner(DNA dna){
        this.genes = dna;
        pos = new Point(mazeStartX, mazeStartY);
        prev = new Point(mazeStartX, mazeStartY);
        numMoves = 0;
        finished = false;
        closestSoFar = shortest.size();
    }
    
    void display(){
        noStroke();
        fill(255,0,255,40);
        rect(pos.x * cellWidth + 1, pos.y*cellHeight + 1, cellWidth - 2, cellHeight - 2);
    }
    
    void eraseDisplay(){
        noStroke();
        fill(255);
        rect(prev.x * cellWidth + 1, prev.y*cellHeight + 1, cellWidth - 2, cellHeight - 2);
    }
    
    void eraseCurrent(){
        noStroke();
        fill(255);
        rect(pos.x * cellWidth + 1, pos.y*cellHeight + 1, cellWidth - 2, cellHeight - 2);
    }
    
    void move(){
        int move = genes.movesToMake[numMoves];
        numMoves++;
        if(finished) return;
        while((maze[pos.y][pos.x] & (1<<move))>0) move = (move+1)%4;
        //if((maze[pos.y][pos.x] & (1<<move))>0)return;
        int i = moves[move][0], j = moves[move][1];
        prev.x = pos.x;
        prev.y = pos.y;
        pos.y+=i;
        pos.x+=j;
        checkPath();
        
        if(pos.equals(new Point(mazeEndX, mazeEndY))) finished = true;
    }
    
    int evaluate(){
        int distRemaining = dists[pos.y][pos.x];
        int closeDif =  max(distRemaining - closestSoFar,0);
        //closeDif = 0;
        if(closestSoFar < distRemaining) distRemaining = closestSoFar;
        int distAway = shortestPath(pos.x, pos.y, mazeStartX, mazeStartY).size();
        int netMoves = 0;
        if(finished == true){
            netMoves = maxMoves - numMoves;
            numMoves = maxMoves;
        }
        
        //println();
        //println("Short: ", shortest.size());
        //println("Rem:", distRemaining);
        //println("Away:", distAway);
        //println("NetMoves:", netMoves);
        
        if(min(distRemaining, closestSoFar) < closest) closest = min(distRemaining, closestSoFar);
        
        fitness = max((shortest.size()-distRemaining-1)*closenessBias - distAway - closeDif*difBias + netMoves,0);
        return fitness;
    }
    
    void checkPath(){
        if(dists[pos.y][pos.x] < closestSoFar){
            closestSoFar = dists[pos.y][pos.x];
            closeMove = numMoves;
        }
    }
}


int log2(int n){
    return floor(log(n)/log(2));
}
