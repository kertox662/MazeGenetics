final int minH = 0, maxH = 12;
final int prioritySwap = 24;
final float mutatingChance = 0.65;
final float mutationRate = 0.03;

final float spliceChance = 0.2;
final int normalSwap = 3;
final float distModifier = 0.65;
final int minMult = 0, maxMult = 3;

private class DNA{
    int[] movesToMake;
    
    DNA(){
        movesToMake = new int[maxMoves];
        for(int i = 0; i < maxMoves; i++){
            movesToMake[i] = floor(random(0,4));
        }
    }
    
    DNA(DNA old){
        movesToMake = old.movesToMake;
    }
    
    DNA crossOver(DNA partner){
        int[] moves = {1,2,4,8};
        DNA[] parents = {this, partner};
        DNA childDna = new DNA();
        boolean doMutation = random(0,1) < mutatingChance;
        for(int i = 0;  i < maxMoves; i++){
            int ind = floor(random(0,2));
            childDna.movesToMake[i] = parents[ind].movesToMake[i];
            if(doMutation && random(0,1) < mutationRate){
                childDna.movesToMake[i] = floor(random(0,4));
            }
        }
        return childDna;
    }
    
    DNA crossInterval(DNA partner){
        boolean doSplice = random(0,1) < spliceChance;
        int interval, spliceInd = moves.length;
        if(doSplice){
            spliceInd = movesToMake.length - floor(random(1,movesToMake.length/2));
            int lenOld = movesToMake.length - spliceInd;
            interval = lenOld/2 + round(random(-lenOld/2, lenOld/2));
        }else
            interval = movesToMake.length/2 + round(random(-movesToMake.length/2, movesToMake.length/2));
        int[] moves = {1,2,4,8};
        DNA[] parents = {this, partner};
        DNA childDna = new DNA();
        boolean doMutation = random(0,1) < mutatingChance;
        for(int i = 0;  i < maxMoves; i++){
            if(i < interval){
                childDna.movesToMake[i] = parents[0].movesToMake[i];
            } else if(i < spliceInd){
                if(doSplice)
                    childDna.movesToMake[i] = parents[1].movesToMake[movesToMake.length-spliceInd+i];
                else
                    childDna.movesToMake[i] = parents[1].movesToMake[i];
            } else{
                childDna.movesToMake[i] = floor(random(0,4));
            }
            if(doMutation && random(0,1) < mutationRate){
                childDna.movesToMake[i] = floor(random(0,4));
            }
        }
        return childDna;
    }
    
    DNA crossIntervalSmart(DNA partner, int moveInd){
        boolean doSplice = random(0,1) < spliceChance;
        int interval, spliceInd = moves.length;
        if(doSplice){
            spliceInd = movesToMake.length - floor(random(1,movesToMake.length/2));
            int lenOld = movesToMake.length - spliceInd;
            interval = lenOld/2 + round(random(-lenOld/2, lenOld/2));
        }else
            interval = movesToMake.length/2 + round(random(-movesToMake.length/2, movesToMake.length/2));
        int[] moves = {1,2,4,8};
        DNA[] parents = {this, partner};
        DNA childDna = new DNA();
        boolean doMutation = random(0,1) < mutatingChance;
        for(int i = 0;  i < maxMoves; i++){
            if(i < interval){
                childDna.movesToMake[i] = parents[0].movesToMake[i];
            } else if(i < spliceInd){
                if(doSplice)
                    childDna.movesToMake[i] = parents[1].movesToMake[max(movesToMake.length-moveInd-spliceInd,0)+i];
                else
                    childDna.movesToMake[i] = parents[1].movesToMake[i];
            } else{
                childDna.movesToMake[i] = floor(random(0,4));
            }
            if(doMutation && random(0,1) < mutationRate){
                childDna.movesToMake[i] = floor(random(0,4));
            }
        }
        return childDna;
    }
}
