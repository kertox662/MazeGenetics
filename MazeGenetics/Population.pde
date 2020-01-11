final int popSize = 100;
int maxMoves;
final int baseMates = 5;
final int numRandom = 3;
final int numSurvivors = 10;
final float intervalChance = 0.8;
final float smartIntervalChance = 0.3;

boolean[][] runnerVisited;

private class Population{
    int currentMove;
    Runner[] runners;
    ArrayList<Runner> matingPool;
    int currentRunner;
    boolean doneGeneration;
    Runner best;
    
    int[] fitness;
    
    Population(){
        runners = new Runner[popSize];
        for(int i = 0; i < popSize; i++){
            runners[i] = new Runner();
        }
        currentRunner = 0;
        matingPool = new ArrayList<Runner>();
        fitness = new int[popSize];
        runnerVisited = new boolean[h][w];
        currentMove = 0;
        best = new Runner();
    }
    
    void cleanUp(){
        delay(500);
        background(255);
        drawWalls();
        generationNumber++;
    }
    
    void simulateStep(){
        if(doneGeneration){
            showBest();
            return;
        }
        
        boolean allDone = true;
        for(int i = 0; i < popSize; i++){
            Runner r = runners[i];
            if (r.numMoves >= maxMoves) continue;
            allDone = false;
            r.move();
            r.display();
            if(r.numMoves >= maxMoves || r.finished){
                int fit = r.evaluate();
                if(fit > maxFitness) maxFitness = fit;
                fitness[i] = fit;
            }
        }
        currentMove++;
        if(allDone){
            doneGeneration = true;
            delay(500);
            background(255);
            drawWalls();
            newGeneration();
        }
    }
    
    void showBest(){
        if(best.numMoves < maxMoves){
            best.move();
            best.eraseDisplay();
            best.display();
        } else{
            cleanUp();
            doneGeneration = false;
        }
    }
    
    void newGeneration(){
        matingPool.clear();
        int maxFitness = 0;
        currentMove = 0;
        int[] bestFitness = new int[numSurvivors];
        for(int f : fitness){
            for(int i = 0; i < numSurvivors; i++){
                if(f > bestFitness[i]){
                    for(int j = numSurvivors-1; j >= i+1; j--){
                        bestFitness[j] = bestFitness[j-1];
                    }
                    bestFitness[i] = f;
                    break;
                }
            }
            if(f > maxFitness) maxFitness = f;
        }
        
        for(int i = 0; i < popSize; i++){
            println(runners[i].fitness, maxFitness, bestFitness[0]);
            if(runners[i].fitness >= maxFitness){
                best = new Runner(runners[i].genes);
            }
        }
        
        printArray(bestFitness);
        int lastInd = 0;
        for(int i = 0; i < numSurvivors; i++){
            int nextBest = bestFitness[i];
            for(int curInd = lastInd;curInd < popSize && lastInd < popSize / 5; curInd++){
                int fit = runners[curInd].fitness;
                if(fit < nextBest) continue;
                Runner temp = runners[lastInd];
                runners[lastInd] = new Runner(runners[curInd].genes);
                if(curInd > lastInd)
                    runners[curInd] = temp;
                lastInd++;
            }
        }
        
        //best = new Runner(runners[0].genes);
        
        for(int i = 0; i < popSize; i++){
            fitness[i] = ceil(map(fitness[i], 0, maxFitness, 0, 1) * baseMates);
            for(int m = 0; m < fitness[i] * fitness[i]; m++){
                matingPool.add(runners[i]);
            }
        }
        
        println(lastInd);
        
        for(int i = lastInd; i < popSize-numRandom; i++){
            Runner parentA = matingPool.get(floor(random(0,matingPool.size())));
            Runner parentB = matingPool.get(floor(random(0,matingPool.size())));
            //while(parentA == parentB) parentB = matingPool.get(floor(random(0,matingPool.size())));
            DNA newDNA;
            if(random(0,1) < intervalChance){
                if(random(0,1) < smartIntervalChance)
                    newDNA = parentA.genes.crossIntervalSmart(parentB.genes,parentB.closeMove);
                else
                    newDNA = parentA.genes.crossInterval(parentB.genes);
                
            }
            else
                newDNA = parentA.genes.crossOver(parentB.genes);
            runners[i] = new Runner(newDNA);
        }
        
        for(int i = popSize-1; i >= popSize-numRandom; i--){
            runners[i] = new Runner();
        }
        
        currentRunner = 0;
    }
}
