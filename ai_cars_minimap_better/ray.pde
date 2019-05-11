class ray
{
  PVector pos;
  PVector dir;
  float angle;
  ray(PVector p, float theta)
  {
    pos = p;
    dir = PVector.fromAngle(theta);
    angle = theta;
  }

  ray(float x, float y, float theta)
  {
    this(new PVector(x, y), theta);
  }

  void Rotate(float theta)
  {
    dir.rotate(theta);
  }

  void setangle(float theta)
  {
    dir = PVector.fromAngle(theta);
  }

  void Rotate()
  {
    dir.rotate(radians(.1));
  }

  void setdir(float x, float y)
  {
    dir.x = x-pos.x;
    dir.y = y-pos.y;
    dir.normalize();
  }

  PVector cast(boundary bound)
  {
    float x1 = bound.start.x;
    float y1 = bound.start.y;
    float x2 = bound.end.x;
    float y2 = bound.end.y;

    float x3 = pos.x;
    float y3 = pos.y;
    float x4 = pos.x+dir.x;
    float y4 = pos.y+dir.y;

    float den = (x1 - x2) * (y3 - y4)-(y1-y2) * (x3-x4);
    if (den == 0)
    {
      return null;
    }

    float t = ((x1-x3)*(y3 - y4)-(y1 - y3) * (x3-x4))/den;
    float u = -((x1-x2)*(y1 - y3)-(y1 - y2) * (x1-x3))/den;

    if (t > 0 && t < 1 && u > 0)
    {
      PVector p = new PVector(x1 + t * (x2-x1), y1 + t * (y2-y1));
      return p;
    } else return null;
  }

  void show()
  {
    stroke(255, 100);
    strokeWeight(1);
    pushMatrix();
    translate(pos.x, pos.y);
    line(0, 0, dir.x*10, dir.y*10);
    popMatrix();
  }
}
