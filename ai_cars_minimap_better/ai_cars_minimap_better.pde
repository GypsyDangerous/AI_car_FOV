car c;
float maxD;
ArrayList<boundary> track;
ArrayList<boundary> goal;
ArrayList<PVector> trackpoints;
ArrayList<PVector> innertrackpoints;
boolean start;
ArrayList<car> population, saved;
float TOTAL = 50;
PImage car;
float Sw;
slider speed;
void setup()
{
  size(800, 800);
  Sw = 800;
  car = loadImage("image.png");
  car.resize(50, 25);
  track = new ArrayList<boundary>();
  innertrackpoints = new ArrayList<PVector>();
  trackpoints = new ArrayList<PVector>();
  trackpoints.add(new PVector(50, 700));
  trackpoints.add(new PVector(25, 200));
  trackpoints.add(new PVector(150, 50));
  trackpoints.add(new PVector(550, 50));
  trackpoints.add(new PVector(700, 100));
  trackpoints.add(new PVector(750, 300));
  trackpoints.add(new PVector(750, 650));
  trackpoints.add(new PVector(650, 750));
  trackpoints.add(new PVector(400, 550));
  innertrackpoints.add(new PVector(135, 550));
  innertrackpoints.add(new PVector(125, 225));
  innertrackpoints.add(new PVector(215, 125));
  innertrackpoints.add(new PVector(530, 125));
  innertrackpoints.add(new PVector(600, 150));
  innertrackpoints.add(new PVector(640, 300));
  innertrackpoints.add(new PVector(640, 600));
  innertrackpoints.add(new PVector(640, 600));
  innertrackpoints.add(new PVector(400, 450));
  goal = new ArrayList<boundary>();
  for (int i = 0; i < trackpoints.size(); i++)
  {
    goal.add(new boundary(trackpoints.get(i), innertrackpoints.get(i)));
  }

  for (int i = 0; i < trackpoints.size(); i++)
  {
    int future = (i+1)%trackpoints.size();
    PVector a = trackpoints.get(i);
    PVector b = trackpoints.get(future);
    track.add(new boundary(a, b));
  }
  for (int i = 0; i < innertrackpoints.size(); i++)
  {
    int future = (i+1)%innertrackpoints.size();
    PVector a = innertrackpoints.get(i);
    PVector b = innertrackpoints.get(future);
    track.add(new boundary(a, b));
  }
  population = new ArrayList<car>();
  saved = new ArrayList<car>();
  for (int i = 0; i < TOTAL; i++)
  {
    population.add(new car(Sw/2, 87.5, 25, 50));
  }
  maxD = dist(0, 0, Sw, height);
  speed = new slider(1, 10, 1, width/2, height-25, .25);
}

void draw()
{
  background(51);
  speed.slide();
  speed.run();
  scale(.25);
  if (start) 
  {
    stroke(255);
    strokeWeight(1);
    fill(255);
    for (int j = 0; j < round(speed.value()); j++)
    {
      for (car c : population)
      {
        c.update();
        c.steer();
        c.think(track);
      }
      for (boundary b : track)
      {
        for (int i = population.size()-1; i >= 0; i--)
        {
          car c = population.get(i);

          if (c.hit(b))
          {
            saved.add(c);
            population.remove(i);
          }
        }
      }
    }

    if (population.size() <= 0)
    {
      nextGeneration();
    }
  }
  for (car c : population)
    c.fps();

  showtrack();
  for (car c : population)
  {
    c.show();
  }

  for (car c : population)
  {
    if (c == best())
    {
      c.highlight = true;
    } else
      c.highlight = false;
  }
  //for (boundary b : track)
  //{
  //  b.show();
  //}
}

void mousePressed()
{
  start = true;
}

void showtrack()
{
  strokeWeight(5);
  stroke(255);
  beginShape();
  fill(51);
  for (PVector p : trackpoints)
  {
    vertex(p.x, p.y);
  }

  endShape(CLOSE);
  beginShape();

  for (PVector p : innertrackpoints)
  {
    vertex(p.x, p.y);
  }
  endShape(CLOSE);

  //for (boundary b : goal)
  //{
  //  b.show();
  //}
}
