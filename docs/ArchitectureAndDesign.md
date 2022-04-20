
## Architecture and Design

The Uni Moodle Module (UMM) is a module that allows users of the Uni App to access their Moodle pages. 

To do so makes use of Sigarra to list the curricular units and checks if a Moodle page is avaialable. Then accesses Moodle and allow users to view the sections in the available curricular units and caching them in the device to later offline visualization. It also allows to download and cache of files and to follow external links integrates in the various sections.

### Logical architecture

This section documents the high-level logical structure of the code (Logical View).

![LogicalView](https://github.com/LEIC-ES-2021-22/3LEIC05T1/blob/26321db483a64e0927206c15b727581a8bac9ce4/docs/Diagrams/Package_Diagram.drawio.png)

* **UI:** responsible for displaying the app and interacting with the user.
* **Bussiness Logic:** acts as the coordinator between the UI and the Persistence layers, since it is responsible for, according to the actions of the user, managing and accessing the data that is locally stored, while also accessing the information from external services (Moodle UP and Sigarra).
* **Persistence:** contains all the data that is locally stored (downloaded files, sections and forum topics).
* **Sigarra:** external module used to obtain information regarding the curricular units the user is enrolled in.
* **Moodle UP:** external module used to obtain information about the curricular units' Moodle page and its contents (sections and respective activities such as files, links, forum and events).

### Physical architecture
<div align=center>
<img alt="Deployment view" src=https://github.com/LEIC-ES-2021-22/3LEIC05T1/blob/main/docs/Diagrams/Physical_architecture.drawio.png></img>
</div>

- Sigarra: It is queried for the curricular units the student is currently attending.

- Moodle: Used to get sections and file

- User client machine: Hosts the Uni app

- Uni app with Moodle module: Allows students to access an assortment of information related with classes and student's life. The Moodle module allows users to access Moodle pages right from the Uni app.

### Vertical prototype

<div align=center>
<img alt="Tab on the right with the Moodle option" src=https://github.com/LEIC-ES-2021-22/3LEIC05T1/blob/main/docs/images/vertical_prototype/vertical_prototype_0.png></img>
<img alt="Moodle page with a card representing a curricular unit" src=https://github.com/LEIC-ES-2021-22/3LEIC05T1/blob/main/docs/images/vertical_prototype/vertical_prototype_1.png></img>
</div>

Based on the already existing code of the Uni app, we added an option to access the Uni Moodle Module from the *drawer* menu and a page with a *card* representing a curricular unit.
