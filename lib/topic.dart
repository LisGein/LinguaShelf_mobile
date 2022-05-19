
enum Topic {
  CallDoctor,
  CallPlumber,
  Unknown
}

Topic strToEnum(String t) {
  switch (t) {
    case "call_doctor":
      return Topic.CallDoctor;
    case "call_plumber":
      return Topic.CallPlumber;
    default:
      return Topic.Unknown;
  }
}
