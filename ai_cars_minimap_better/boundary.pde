class boundary
{
  PVector start, end;
  boundary(float x1, float y1, float x2, float y2)
  {
    start = new PVector(x1, y1);
    end = new PVector(x2, y2);
  }

  boundary(PVector s, PVector e)
  {
    start = s.copy();
    end = e.copy();
  }

  void show()
  {
    stroke(255);
    line(start.x, start.y, end.x, end.y);
  }

  PVector thisline()
  {
    return PVector.sub(end, start);
  }

  void set(PVector a, PVector b)
  {
    start.set(a);
    end.set(b);
  }

  float distto(PVector point)
  {
    PVector proj = getNormalPointinline(point, start, end);
    return point.dist(proj);
  }

  PVector normal()
  {
    PVector l = thisline();
    PVector normal = new PVector(-l.y, l.x);
    normal.normalize();
    return normal;
  }

  float length()
  {
    return start.dist(end);
  }

  PVector midpoint()
  {
    PVector mid = PVector.add(start, end);
    mid.div(2);
    return mid;
  }
  
  PVector projection(PVector p)
  {
   return getNormalPointinline(p, start, end); 
  }

  boolean intersectsLine(boundary l)
  {
    return intersectionpointLine(l) != null;
  }

  PVector intersectionpointLine(boundary l)
  {
    float x1 = l.start.x;
    float y1 = l.start.y;
    float x2 = l.end.x;
    float y2 = l.end.y;

    float x3 = start.x;
    float y3 = start.y;
    float x4 = end.x;
    float y4 = end.y;

    float den = (x1 - x2) * (y3 - y4)-(y1-y2) * (x3-x4);
    if (den == 0)
    {
      return null;
    }

    float t = ((x1-x3)*(y3 - y4)-(y1 - y3) * (x3-x4))/den;
    float u = -((x1-x2)*(y1 - y3)-(y1 - y2) * (x1-x3))/den;

    if (t > 0 && t < 1 && u > 0 && u < 1)
    {
      PVector p = new PVector(x1 + t * (x2-x1), y1 + t * (y2-y1));
      return p;
    } else return null;
  }
}
