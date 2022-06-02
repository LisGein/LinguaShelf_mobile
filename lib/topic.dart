
enum Topic {
  CallDoctor,
  CallPlumber,
  General,
  Unknown
}

Topic strToEnum(String t) {
  switch (t) {
    case "call_doctor":
      return Topic.CallDoctor;
    case "call_plumber":
      return Topic.CallPlumber;
    case "general":
      return Topic.General;
    default:
      return Topic.Unknown;
  }
}
