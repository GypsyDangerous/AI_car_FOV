
float disttoline(boundary a, PVector pos)
{
  PVector proj = getNormalPointinline(pos, a.start, a.end);
  float projdist = pos.dist(proj);
  return projdist;
}

boolean Lintersects(PVector a, PVector b, particle c)
{
  PVector proj = getNormalPointinline(c.pos, a, b);
  return c.pos.dist(proj) < c.r;
}

PVector getNormalPointinline(PVector p, PVector a, PVector b) {
  // Vector from a to p
  PVector ap = PVector.sub(p, a);
  // Vector from a to b
  PVector ab = PVector.sub(b, a);
  ab.normalize(); // Normalize the line
  // Project vector "diff" onto line by using the dot product
  ab.mult(constrain(ap.dot(ab), 0, a.dist(b)));
  PVector normalPoint = PVector.add(a, ab);
  return normalPoint;
}

PVector getNormalPoint(PVector p, PVector a, PVector b) {
  // Vector from a to p
  PVector ap = PVector.sub(p, a);
  // Vector from a to b
  PVector ab = PVector.sub(b, a);
  ab.normalize(); // Normalize the line
  // Project vector "diff" onto line by using the dot product
  ab.mult(ap.dot(ab));
  PVector normalPoint = PVector.add(a, ab);
  return normalPoint;
}
