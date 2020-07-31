class Wallet{
  String id;
  String user_id;
  String points;


  Wallet();

  Wallet.fromJSON(Map<String, dynamic> jsonMap){
    try{
      id = jsonMap['id'].toString();
      points=jsonMap['points'].toString();
      user_id=jsonMap['user_id'];
    }catch(e){
      print(e);
    }
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["points"] = points;
    map["user_id"] = user_id;
  }
}