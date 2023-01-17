enum CoherentNoiseInterpolationType {
  integer('integer / bi-integer'),
  linear('linear / bi-linear'),
  cubic('cubic / bi-cubic'),
  cubicS('cubic-s / bi-cubic-s'),
  cosineS('cosine-s / bi-cosine-s'),
  quinticS('quintic-s / bi-quintic-s');

  const CoherentNoiseInterpolationType(this.name);

  final String name;
}
