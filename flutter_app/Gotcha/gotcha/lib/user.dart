
class User {
  String id;
  String name;
  String residentStatus;
  String unlockOptions;
  String notifyMe;
  String image;

  User({this.id, this.name, this.residentStatus, this.unlockOptions,
    this.notifyMe, this.image});
}

List<User> users = [
  User(
    id: "1",
    name: "George",
    residentStatus: "Resident",
    unlockOptions: "Always",
    notifyMe: "No",
    image: "furry_george.jpg",
  ),
  User(
    id: "2",
    name: "John",
    residentStatus: "Unknown",
    unlockOptions: "Prohibited",
    notifyMe: "Yes",
    image: "user-placeholder.png",
  ),
  User(
    id: "2",
    name: "Joe",
    residentStatus: "Unknown",
    unlockOptions: "Prohibited",
    notifyMe: "Yes",
    image: "user-placeholder.png",
  ),
  User(
    id: "2",
    name: "Jan",
    residentStatus: "Unknown",
    unlockOptions: "Prohibited",
    notifyMe: "Yes",
    image: "user-placeholder.png",
  ),
  User(
    id: "2",
    name: "Jim",
    residentStatus: "Unknown",
    unlockOptions: "Prohibited",
    notifyMe: "Yes",
    image: "user-placeholder.png",
  ),
  User(
    id: "2",
    name: "Jerry",
    residentStatus: "Unknown",
    unlockOptions: "Prohibited",
    notifyMe: "Yes",
    image: "user-placeholder.png",
  ),
];