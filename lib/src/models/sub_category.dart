class SubCategory{
  String name;
  String image;

  int id;

  SubCategory();


   SubCategory.fromJson(Map<String, dynamic> jsonMap){
    id=jsonMap['id'];
    name=jsonMap['name'];
    image=jsonMap['image'];
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['id']=id;
    map['name']=name;
    map['image']=image;

    return map;
  }

  String toString() {
    return '{ ${this.id},${this.name},${this.image}  }';
  }
}