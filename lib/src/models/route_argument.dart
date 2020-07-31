class RouteArgument {
  String id;
  String heroTag;
  String name;
  dynamic param;

  RouteArgument({this.id, this.heroTag, this.param, this.name});

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
