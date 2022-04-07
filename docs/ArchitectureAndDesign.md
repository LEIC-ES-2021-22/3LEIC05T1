
## Architecture and Design

### Logical architecture

This section documents the high-level logical structure of the code (Logical View).

![LogicalView](https://github.com/LEIC-ES-2021-22/3LEIC05T1/blob/26321db483a64e0927206c15b727581a8bac9ce4/docs/Diagrams/Package_Diagram.drawio.png)

* **UI:** responsible for displaying the app and interacting with the user.
* **Bussiness Logic:** acts as the coordinator between the UI and the Persistence layers, since it is responsible for, according to the actions of the user, managing and accessing the data that is locally stored, while also accessing the information from external services (Moodle UP and Sigarra).
* **Persistence:** contains all the data that is locally stored (downloaded files, sections and forum topics).
* **Sigarra:** external module used to obtain information regarding the curricular units the user is enrolled in.
* **Moodle UP:** external module used to obtain information about the curricular units' Moodle page and its contents (sections and respective activities such as files, links, forum and events).

### Physical architecture

![DeploymentView]()

### Vertical prototype
