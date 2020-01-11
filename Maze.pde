void makeMaze(){
    int startX = floor(random(0,w));
    int startY = floor(random(0,h));
    visited[startY][startX] = true;
    generate(startX,startY);
    for(int i = 0; i < numHoles; i++){
        int[] dirs = {1,2,4,8};
        int[][] neighbours = {{-1,0},{0,1},{1,0},{0,-1}};
        int x = floor(random(1,w-1));
        int y = floor(random(1,h-1));
        int d = floor(random(0,4));
        if((maze[y][x] & dirs[d]) > 0){
            maze[y][x] -= dirs[d];
            y += neighbours[d][0];
            x += neighbours[d][1];
            maze[y][x] -= dirs[(d+2)%4];
        }
    }
}

int[][] shuffleNeighbours(){
    int[][] neighbours = {{-1,0},{1,0},{0,-1},{0,1}};
    for(int i = 0; i < numSwap; i++){
        int a = floor(random(0,4));
        int b = floor(random(0,4));
        while(b == a) b = floor(random(0,4));
        int[] temp = neighbours[a];
        neighbours[a] = neighbours[b];
        neighbours[b] = temp;
    }
    return neighbours;
}

void generate(int x, int y){
    int[][] neighbours = shuffleNeighbours();
    
    for(int m = 0; m < 4; m++){
        int i = neighbours[m][0], j = neighbours[m][1];
        if(y + i < 0 || y + i >= h || x + j < 0 || x + j >= w) continue;
        if(visited[y+i][x+j]) continue;
        visited[y+i][x+j] = true;
        if(j == -1){
            maze[y][x] -= 8;
            maze[y+i][x+j] -= 2;
        } else if(j == 1){
            maze[y][x] -= 2;
            maze[y+i][x+j] -= 8;
        } else if(i == -1){
            maze[y][x] -= 1;
            maze[y+i][x+j] -= 4;
        } else if(i == 1){
            maze[y][x] -= 4;
            maze[y+i][x+j] -= 1;
        }
        generate(x+j, y+i);
    }
}
