import 'package:flutter/foundation.dart';
import 'friend.dart';

class FriendList with ChangeNotifier {

  List<Friend> _friendList = [
    Friend(email:"aaa", name:'권기남'),
    Friend(email:"bb", name:'최문석'),
    Friend(email:"cc", name:'송레기'),
  ];

  List<Friend> get friends => _friendList;
  int get length => _friendList.length;
  int getIndex(String email) => _friendList.indexWhere((friend) => email == friend.email);
  Friend getItemByEmail(String email) => _friendList.elementAt(getIndex(email));

  Friend getItemByIndex(int index) => _friendList.elementAt(index);
  void addItem(Friend friend) {
    _friendList.add(friend);
    notifyListeners();
  }
  void deleteItem(String email) {
    _friendList.removeAt(getIndex(email));
    notifyListeners();
  }
}