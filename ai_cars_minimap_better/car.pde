class car extends rectangle
{
  particle vision, view;
  NeuralNetwork brain;
  float dir;
  float[] inputs;
  float fitness, score;
  boolean alive, highlight;
  int goalindex = 3;
  float goalcount;
  float lapcount;
  float rotcount;
  car(float x, float y, float w, float h, NeuralNetwork copy)
  {
    super(x, y, w, h);
    vision = new particle(pos, 60, w/2, true);
    view = new particle(pos, 60, w/2, false);
    if (copy == null)
      brain = new NeuralNetwork(10, 16, 6);
    else
      brain = copy.copy();
    inputs = new float[10];
    alive = true;
  }

  car(float x, float y, float w, float h)
  {
    this(x, y, w, h, null);
  }

  void update()
  {
    if (alive)
    {
      pos.add(vel);
      vel.add(acc);
      vel.limit(1);
      acc.mult(0);
      if (frameCount % 100 == 0)
      {
        score++;
      }
      goalcount++;
      if (hit(goal.get(goalindex)))
      {
        score +=(25-goalcount);
        goalcount = 0;
        goalindex += 1;
        goalindex = goalindex%goal.size();
      }
      vision.setR(vel.heading());
      vision.carupdate();
      view.update();
      view.setR(vel.heading());
      super.update();
    }
  }

  void fps()
  {
    if (highlight)
    {
      pushMatrix();
      scale(4);
      ArrayList<PVector> scene = view.look(track);
      float[] scenedist = new float[scene.size()];
      for (int i = 0; i < scene.size(); i++)
      {
        scenedist[i] = pos.dist(scene.get(i));
      }

      float w = width/scenedist.length;
      for (int i = 0; i < scenedist.length; i++)
      {
        noStroke();
        ray r = view.rays.get(i);
        float theta = r.dir.heading() - vel.heading();
        float c = map(scenedist[i]*cos(theta), 0, width/1.25, 255, 0);
        float h = map(scenedist[i]*cos(theta), 0, width/1.25, height/1.5, 0);
        fill(c);
        rectMode(CENTER);
        rect(i*w+w/2, height/2, w, h);
      }
      popMatrix();
    }
  }

  float distto(boundary b)
  {
    PVector proj = b.projection(pos);
    return pos.dist(proj);
  }

  float closestgoaldist()
  {
    float record = Float.POSITIVE_INFINITY;
    for (boundary b : goal)
    {
      float d = distto(b);
      if (d < record)
      {
        record = d;
      }
    }
    return record;
  }

  void mutate()
  {
    brain.mutate(.01);
  }

  boolean hit(boundary wall)
  {
    for (boundary b : sides)
    {
      if (b.intersectsLine(wall))
      {
        return true;
      }
    }
    return false;
  }

  void think(ArrayList<boundary> track)
  {
    ArrayList<PVector> view = vision.look(track);
    for (int i = 0; i < view.size(); i++)
    {
      inputs[i] = pos.dist(view.get(i))/maxD;
    }

    inputs[inputs.length-1] = vel.mag()/10;
    inputs[inputs.length-2] = closestgoaldist()/maxD;

    float[] guesses = brain.feedforward(inputs);

    if (guesses[0] < guesses[1])
    {
      steer(radians(1));
    } else if (guesses[0] > guesses[1])
    {
      steer(-radians(1));
    }
    if (guesses[2] > guesses[3])
    {
      accelerate(min(guesses[4], .5), 1);
    } else if (guesses[2] < guesses[3])
    {
      accelerate(-min(guesses[4], .5), -1);
    }
  }

  void accelerate(float power, float dir)
  {
    acc = vel.copy();
    if (acc.mag() == 0)
    {
      acc = PVector.fromAngle(vel.heading());
    }
    acc.setMag(power);
    acc.mult(dir);
  }

  void steer()
  {
    vel.rotate(dir);
  }

  void steer(float theta)
  {
    dir = theta;
  }

  void show()
  {
    point(pos.x, pos.y);
    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    //rect(0, 0, w, h);
    imageMode(CENTER);
    image(car, 0, 0);

    popMatrix();
    //vision.show();
    //for (int i = 0; i < sides.size(); i++)
    //{
    //  sides.get(i).show();
    //}
  }
}
