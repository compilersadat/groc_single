class WalletTransaction{
  String id;
  String user_id;
  String points;
  String type;
  String date;

  WalletTransaction();

  WalletTransaction.fromJSON(Map<String, dynamic> jsonMap){
    try{
      id = jsonMap['id'].toString();
      user_id = jsonMap['user_id'].toString();
      points=jsonMap['points'].toString();
      type=jsonMap['type'];
      date=jsonMap['date'].toString();
    }catch(e){
      print(e);
    }
  }

  Map toMap(){
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user_id"] = user_id;
    map["points"] = points;
    map["type"] = type;
    map["date"] = date;
  }
}