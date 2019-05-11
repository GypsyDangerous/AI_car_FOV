void nextGeneration()
{
  calculateFitness();
  for (int i = 0; i < TOTAL; i++)
  {
    population.add(pickOne());
  }
  saved.clear();
}

car pickOne()
{
  int index = 0;
  float r = random(1);
  while (r > 0) 
  {
    r -= saved.get(index).fitness;
    index++;
  }
  index--;
  car b = saved.get(index);
  car child = new car(Sw/2, 87.5, 25, 50, b.brain);
  child.mutate();
  return child;
}

car best()
{
  float record = Float.NEGATIVE_INFINITY;
  car best = null;
  for (car c : population)
  {
    if (c.score > record)
    {
      record = c.score;
      best = c;
    }
  }
  return best;
}

void calculateFitness()
{
  float sum = 0;
  for (car b : saved)
  {
    sum += b.score;
  }

  for (car b : saved)
  {
    b.fitness = b.score/sum;
  }
}
