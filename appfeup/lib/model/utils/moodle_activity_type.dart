enum MoodleActivityType {
  sigarracourseinfo,
  summaries, //ignore for now
  forum, // ignore for now
  resource,
  page,
  url,
  quiz, // ignore
  assign, //ignore
  choicegroup, //ignore
  label,
}

MoodleActivityType stringToActivityEnum(String type){
  switch(type){
    case 'sigarracourseinfo':
      return MoodleActivityType.sigarracourseinfo;
    case 'summaries':
      return MoodleActivityType.summaries;
    case 'forum':
      return MoodleActivityType.forum;
    case 'resource':
      return MoodleActivityType.resource;
    case 'page':
      return MoodleActivityType.page;
    case 'url':
      return MoodleActivityType.url;
    case 'quiz':
        return MoodleActivityType.quiz;
    case 'assign':
      return MoodleActivityType.assign;
    case 'choicegroup':
      return MoodleActivityType.choicegroup;
    case 'label':
      return MoodleActivityType.label;
    default:
      return null;
  }
}
