import 'package:flutter/material.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/moodle/activities/page.dart';
import 'package:uni/model/entities/moodle/activities/sigarraCourseInfo.dart';
import 'package:uni/model/entities/moodle/section.dart';
import 'package:uni/view/Pages/unnamed_page_view.dart';
import 'package:uni/view/Widgets/section_card.dart';

class MoodlePageView extends StatefulWidget {
  CourseUnit uc;
  MoodlePageView(this.uc);
  @override
  State<StatefulWidget> createState() => MoodlePageViewState(this.uc);
}

/// Manages the 'Personal user page' section.
class MoodlePageViewState extends UnnamedPageView {
  CourseUnit uc;
  MoodlePageViewState(this.uc);

  @override
  Widget getBody(BuildContext context) {
    
    return ListView(
      children: 
          createSectionsList(context)
        
    );
  }

  @override
  Widget getTopRightButton(BuildContext context) {
    return Container();
  }

  List<Widget> createSectionsList(BuildContext context){
    final List<Widget> list = [
      Container(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
          child:
            Text(
              this.uc.name,
              style:
                Theme.of(context).textTheme.headline6.apply(fontSizeFactor: 1.3),)

          ),
      ];
    final Map<String, String> content = Map();
    content['Ocorrência: 2021/2022 - 2S'] = 'Ativa?    Sim\nUnidade Responsável:    Departamento de Engenharia Informática\nCurso/CE Responsável:    Licenciatura em Engenharia Informática e Computação';
    content['Língua de trabalho'] = 'Português';
    content['Objetivos'] = 'Familiarizar-se com os métodos de engenharia e gestão necessários ao desenvolvimento de sistemas de software complexos e/ou em larga escala, de forma economicamente eficaz e com elevada qualidade.';
    content['Melhoria de Classificação'] = 'A classificação da componente EF pode ser melhorada na época de recurso.\nRealização de trabalhos alternativos na época seguinte da disciplina.';

    final List<String> pageContent = ['Have a look at these pages:', 'https://docs.oracle.com/javase/tutorial/rmi/overview.html','https://docs.oracle.com/javase/8/docs/technotes/guides/rmi/hello/hello-world.html','To run the code in Linux based system (see explanation in the link above):','rmiregistry &','java -Djava.rmi.server.codebase=file:./ example.hello.Server &','java example.hello.Client'];

    final List<Section> sections = [Section(1, 'Section 1', 'This the section 1', [SigarraCourseInfo('UC info', 'Engenharia de software', content), PageActivity("Example RMI", 'Example RMI', pageContent)])];

    for (Section section in sections) {
          list.add(SectionCard(section));
    }

    return list;
  }
}

  /// Returns a list with all the children widgets of this page.
  /*List<Widget> childrenList(BuildContext context) {
    final List<Widget> list = [];
    list.add(Padding(padding: const EdgeInsets.all(5.0)));
    list.add(profileInfo(context));
    list.add(Padding(padding: const EdgeInsets.all(5.0)));
    for (var i = 0; i < courses.length; i++) {
      list.add(CourseInfoCard(
          course: courses[i],
          courseState:
              currentState == null ? '?' : currentState[courses[i].name]));
      list.add(Padding(padding: const EdgeInsets.all(5.0)));
    }
    list.add(PrintInfoCard());
    list.add(Padding(padding: const EdgeInsets.all(5.0)));
    list.add(AccountInfoCard());
    return list;
  }

  /// Returns a widget with the user's profile info (Picture, name and email).
  Widget profileInfo(BuildContext context) {
    return StoreConnector<AppState, Future<File>>(
      converter: (store) => loadProfilePic(store),
      builder: (context, profilePicFile) => FutureBuilder(
        future: profilePicFile,
        builder: (BuildContext context, AsyncSnapshot<File> profilePic) =>
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: getDecorageImage(profilePic.data))),
            Padding(padding: const EdgeInsets.all(8.0)),
            Text(name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400)),
            Padding(padding: const EdgeInsets.all(5.0)),
            Text(email,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}*/
