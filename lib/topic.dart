
enum Topic {
  callDoctor,
  callPlumber,
  general,
  unknown
}

Topic strToEnum(String t) {
  switch (t) {
    case "call_doctor":
      return Topic.callDoctor;
    case "call_plumber":
      return Topic.callPlumber;
    case "general":
      return Topic.general;
    default:
      return Topic.unknown;
  }
}
