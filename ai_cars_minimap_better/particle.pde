class particle
{
  PVector 
    pos, 
    vel;

  ArrayList<ray> 
    rays;

  float 
    rotation, 
    speed, 
    fov, 
    r;

  boolean 
    highlight;

  particle(float x, float y, float view, float ra)
  {
    pos = new PVector(x, y);
    vel = new PVector();
    rays = new ArrayList<ray>();
    fov = radians(view);
    updatefov();
    r = ra;
  }

  particle(float x, float y, float r)
  {
    this(x, y, 60, r);
  }

  particle(PVector p, float view, float r, boolean car)
  {
    pos = p;
    rays = new ArrayList<ray>();
    fov = radians(view);
    if (!car)
      updatefov();
    else
      carview();
    this.r = r;
  }

  void updatefov(float fov)
  {
    this.fov = fov;
  }

  void updatefov()
  {
    for (float i = -fov/2; i < fov/2; i+=radians(1))
    {
      rays.add(new ray(pos, i));
    }
  }

  void carview()
  {
    rays = new ArrayList<ray>();
    rays.add(new ray(pos, -radians(30)));
    rays.add(new ray(pos, radians(30)));
    rays.add(new ray(pos, PI+HALF_PI));
    rays.add(new ray(pos, TWO_PI+HALF_PI));
    rays.add(new ray(pos, PI+(-radians(30))));
    rays.add(new ray(pos, PI+radians(30)));
    rays.add(new ray(pos, PI));
    rays.add(new ray(pos, TWO_PI));
  }

  void Rotate(float theta)
  {
    rotation += theta;
  }

  void setR(float theta)
  {
    rotation = theta;
  }

  void update()
  {
    int index = 0;
    for (float i = -(fov/2); i < (fov/2); i += radians(1))
    {
      rays.get(min(index, rays.size()-1)).setangle(i+rotation);
      index++;
    }
    vel = PVector.fromAngle(rotation);
    vel.setMag(speed);
    pos.add(vel);
  }

  void carupdate()
  {
    int index = 0;
    for (ray r : rays)
    {
      r.setangle(r.angle+rotation);
    }
  }

  void look(boundary bound)
  {
    for (ray r : rays)
    {
      PVector pt = r.cast(bound);
      if (pt != null)
      {
        line(pos.x, pos.y, pt.x, pt.y);
      }
    }
  }

  ArrayList<PVector> look(ArrayList<boundary> bounds)
  {
    ArrayList<PVector> view = new ArrayList<PVector>();
    for (ray r : rays)
    {
      PVector closest = null;
      float record = Float.POSITIVE_INFINITY;
      for (boundary b : bounds)
      {
        PVector pt = r.cast(b);
        if (pt != null)
        {
          float d = pt.dist(pos);
          if (d < record)
          {
            record = d;
            closest = pt;
          }
        }
      }
      if (closest != null)
      {
        view.add(closest.copy());
        //stroke(255, 100);
        //strokeWeight(1);
        //line(pos.x, pos.y, closest.x, closest.y);
        //strokeWeight(1);
      }
    }
    return view;
  }

  boolean intersectsLine(boundary bound)
  {
    return Lintersects(bound.start, bound.end, this);
  }

  boolean intersectsLine(ArrayList<boundary> bounds)
  {
    for (boundary bound : bounds)
    {
      if (intersectsLine(bound))
        return true;
    }
    return false;
  }

  void update(float x, float y)
  {
    pos.set(x, y);
  }

  void show()
  {
    strokeWeight(1);
    for (ray r : rays)
    {
      r.show();
    }
    //circle(pos.x, pos.y, r*2);
  }
}
