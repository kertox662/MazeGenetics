import java.util.Queue;
Queue<ArrayList<Point>> paths;
Queue<FloodNode> floodQ;
boolean[][] pathVisited;

class Point{
    int x,y;
    Point(int x, int y){
        this.x = x;
        this.y = y;
    }
    boolean equals(Point other){
        if(this.x == other.x && this.y == other.y)
            return true;
        return false;
    }
}

class FloodNode extends Point{
    int d;
    FloodNode(int x, int y, int d){
        super(x,y);
        this.d = d;
    }
    
    boolean equals(FloodNode other){
        if(this.x == other.x && this.y == other.y && this.d == other.d)
            return true;
        return false;
    }
}

ArrayList<Point> shortestPath(){
    shortest = shortestPath(mazeStartX, mazeStartY, mazeEndX, mazeEndY);
    return shortest;
}

ArrayList<Point> shortestPath(int sx, int sy, int ex, int ey){
    Point finalPoint = new Point(ex, ey);
    pathVisited = new boolean[h][w];
    paths.clear();
    
    ArrayList<Point> finalPath = null;
    ArrayList<Point> firstPath = new ArrayList<Point>();
    firstPath.add(new Point(sx, sy));
    paths.add(firstPath);
    while(!paths.isEmpty()){
        ArrayList<Point> curPath = paths.remove();
        Point last = curPath.get(curPath.size()-1);
        int[] dirs = {1,2,4,8};
        for(int d : dirs){
            if((maze[last.y][last.x] & d) == 0){
                int i=0, j=0;
                switch(d){
                    case 1:
                        i = -1;
                        j = 0;
                        break;
                    case 2:
                        i = 0;
                        j = 1;
                        break;
                    case 4:
                        i = 1;
                        j = 0;
                        break;
                    case 8:
                        i = 0;
                        j = -1;
                        break;
                }
                Point nextPoint = new Point(last.x + j, last.y + i);
                if(pathVisited[nextPoint.y][nextPoint.x]) continue;
                pathVisited[nextPoint.y][nextPoint.x] = true;
                ArrayList<Point> newPath = new ArrayList<Point>();
                for(Point p : curPath) newPath.add(p);
                newPath.add(nextPoint);
                if(nextPoint.equals(finalPoint)) return newPath;
                paths.add(newPath);
            }
        }
    }
    
    
    return finalPath;
}

int shortestDist(int x, int y){
    return dists[y][x];
}    

void floodFill(int sx, int sy){
    FloodNode firstNode = new FloodNode(sx, sy, 0);
    visitedFlood[sy][sx] = true;
    floodQ.add(firstNode);
    
    while(!floodQ.isEmpty()){
        FloodNode next = floodQ.remove();
        int x = next.x, y = next.y, dist = next.d;
        dists[y][x] = dist;
        int d = maze[y][x];
        int[] dirs = {1,2,4,8};
        
        for(int i = 0; i < 4; i++){
            if((d & dirs[i]) == 0){
                int dy = moves[i][0], dx = moves[i][1];
                if(!visitedFlood[y+dy][x+dx]){
                    FloodNode check = new FloodNode(x+dx, y + dy, dist+1);
                    visitedFlood[y+dy][x+dx] = true;
                    floodQ.add(check);
                }
            }
        }
    }
}
