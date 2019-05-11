class rectangle
{
  PVector pos, vel, acc, size, wsize, psize, pwsize;
  float w, h;
  ArrayList<boundary> sides;

  rectangle(float x, float y, float wi, float he)
  {
    pos = new PVector(x, y);
    vel = new PVector();
    acc = new PVector();
    w = wi;
    h = he;
    size = new PVector(w, h);
    size.mult(.5);
    psize = size.copy();
    wsize = new PVector(-w, h);
    wsize.mult(.5);
    pwsize = wsize.copy();
    generatecorners();
  }

  void update()
  {
    generatecorners();
  }

  void generatecorners()
  {
    sides = new ArrayList<boundary>();

    size = psize.copy();
    wsize = pwsize.copy();

    size.rotate(vel.heading()+HALF_PI);
    wsize.rotate(vel.heading()+HALF_PI);

    PVector a = PVector.sub(pos, size);
    PVector b = PVector.sub(pos, wsize);
    PVector c = PVector.add(pos, size);
    PVector d = PVector.add(pos, wsize);

    sides.add(new boundary(a, b));
    sides.add(new boundary(b, c));
    sides.add(new boundary(c, d));
    sides.add(new boundary(d, a));
  }
}
