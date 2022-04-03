## Requirements

### Use Case Model

The Uni Moodle Module, UMM for short, aims to provide students with an easy way to access Moodle's most useful features, represented by the uses in the next diagram. The aim is to accuratlly assess if the curricular units with Moodle pages using its SIGARRA page and to serve the Moodle functionality using the Uni app.

![](./Diagrams/Use_case_model.drawio.png)


The cache mechanisms referenced work by saving to local storage the downloaded files, sections or forum topics, each time they're loaded from the Internet. 

|||
| --- | --- |
| *Name* | List Curricular Units |
| *Actor* |  Student | 
| *Description* | The student access their list of current curricular units provided by Sigarra |
| *Preconditions* | - The student must be authenticated in UNI |
| *Postconditions* | - The student is in the curricular units page |
| *Normal flow* | 1. The student accesses the uni app.<br> 2. The student selects the "Unidades Curriculares" menu option. *See note below.* <br> 3. The list of curricular units is shown; if the student isn't registered in any curricular unit the message "Não está inscrito em qualquer UC" should be displayed. |
| *Exceptions* | - [No Internet Connection] If no Internet connecion is available and there's no cached curricular units list, an alert is displayed. |

Note: Multi language support isn't available in the main Uni app, therefore the module will only support Portuguese.

|||
| --- | --- |
| *Name* | Access Sections of a Curricular Unit |
| *Actor* |  Student | 
| *Description* | The student accesses the Moodle's sections of the selected curricular unit through the Uni app. |
| *Preconditions* | - The student must be authenticated in UNI <br> - The student must be in the curricular units page. |
| *Postconditions* | - The student views the curricular units sections including description, links and documents. |
| *Normal flow* | 1. The student selects the curricular unit. <br> 2. The sections of the selected curricular unit are shown. |
| *Alternative flows* | - [Moodle page not available] If the curricular unit does not have a Moodle page the clicking on the curricular unit will result in an alert notifying the student |

|||
| --- | --- |
| *Name* | Download and Open Files |
| *Actor* | Student | 
| *Description* | The student downloads and opens a file available in Moodle |
| *Preconditions* | - The student is in a Moodle section. |
| *Postconditions* | - The selected file is stored locally for later use without the need to download again. <br> - The selected file is opened. |
| *Normal flow* | 1. The student clicks on the file. <br> 2. The system prompts the user to choose how to open the file. *See note below.* <br> 3. The selected app opens the file|
| *Alternative flows and exceptions* | - [No Internet Connection] If there is no Internet connection nor the file is already stored locally, in step 2 of the normal flow an alert message is shown. |

Note: When requested, the operating system (OS) opens files using apps external to the uni app. If no default app is defined for a given file type the user is asked to select one to do so.

|||
| --- | --- |
| *Name* | View external web page |
| *Actor* | Student | 
| *Description* | The student follows a link referenced by a Moodle section. |
| *Preconditions* | - The student is in a Moodle section. |
| *Postconditions* | - The link selected by the student opens in the web browser  |
| *Normal flow* | 1. The student clicks on the link. <br> 2. The system prompts the user to choose what browser app to use. <br> 3. The selected browser opens the page|


|||
| --- | --- |
| *Name* | Access Curricular Units Forum |
| *Actor* |  Student | 
| *Description* | The student accesses the selected curricular unit forum. |
| *Preconditions* | - The student is in the curricular unit's Moodle page. |
| *Postconditions* | - The student views the curricular unit forum. |
| *Normal flow* | 1. The student selects the Moodle forum option.<br> 2. The student views the curricular unit's forum.<br> 3. The student selects a forum thread.<br> 4. The student sees the thread messages. |
| *Exceptions* | - [No Internet Connection] If no Internet connection is available nor the forum is already stored locally,in step 2 of the normal flow the forum is not accessible and the user is notified. |

|||
| --- | --- |
| *Name* | Setup calendar alert based on Moodle's Calendar |
| *Actor* |  Student | 
| *Description* | The student is able to receive notifications, if it is of their interest, of Moodle's Events of a specific curricular unit, through the device's OS notification system. By default, the notifications are activated by all the curricular units the student is enrroled in.|
| *Preconditions* | - The student is registered in the curricular unit and it is in the curricular unit's Moodle page. |
| *Postconditions* | - When activated The student receives notifications concerning future Moodle's events;  |
| *Normal flow* | 1. The student **enables/disables** the notifications, using the bell icon. |