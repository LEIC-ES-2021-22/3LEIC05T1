## Requirements

### Use Case Model


|||
| --- | --- |
| *Name* | List Curricular Units |
| *Actor* |  Student | 
| *Description* | The student accesses the list of current curricular units provided by Sigarra |
| *Preconditions* | - The student must be authenticated in UNI |
| *Postconditions* | - The student is in the curricular units page |
| *Normal flow* | 1. The student accesses the uni app.<br> 2. The student selects the "Unidades Curriculares" menu option. <br> 3. The list of curricular units is shown. |

|||
| --- | --- |
| *Name* | Access Sections of a Curricular Unit |
| *Actor* |  Student | 
| *Description* | The student accesses the Moodle's sections of the selected curricular unit. |
| *Preconditions* | - The student must be authenticated in UNI <br> - The student must be in the curricular units page. |
| *Postconditions* | - The student sees the curricular units sections including description, links and documents. |
| *Normal flow* | 1. The student selects the curricular unit. <br> 2. The student selects the "Moodle" option. <br> 3. The sections of the selected curricular unit are shown. |
| *Alternative flows and exceptions* | 1. [Moodle page not available] If the curricular unit does not have a Moodle page, in step 2 of the normal flow the "Moodle" option is not available. |

|||
| --- | --- |
| *Name* | Download Files |
| *Actor* | Student | 
| *Description* | The student downloads a file available in Moodle |
| *Preconditions* | - The student is in a Moodle section. |
| *Postconditions* | - The selected file is stored locally for later use without the need to download. |
| *Normal flow* | 1. The student clicks on the file. <br> 2. The system prompts the user to choose how to open the file. |
| *Alternative flows and exceptions* | 1. [No Internet Connection] If there is no Internet connection nor the file is already stored locally, in step 2 of the normal flow an error message is shown. |

|||
| --- | --- |
| *Name* | Access Curricular Units Forum |
| *Actor* |  Student | 
| *Description* | The student accesses the selected curricular unit forum. |
| *Preconditions* | - The student is in the curricular unit Moodle page. |
| *Postconditions* | - The student sees the curricular unit forum. |
| *Normal flow* | 1. The student selects the Moodle forum option.<br> 2. The student sees the curricular unit's forum.<br> 3. The student selects a forum thread.<br> 4. The student sees the thread messages. |

|||
| --- | --- |
| *Name* | Setup calendar alert based on Moodle's Calendar |
| *Actor* |  Student | 
| *Description* | . |
| *Preconditions* | - The student has the UNI notifications enabled. <br> - The student has events on the calendar. |
| *Postconditions* | - The customer gets the electronic tickets with a QR code. <br> - The customer is charged of the tickets’ cost, and the seller credited. <br> - Information of tickets sold & seats available for the event is updated. |
| *Normal flow* | 1. The customer accesses the uni app.<br> 2. The system shows the list of events with tickets on-sale.<br> 3. The customer selects the event and the number of tickets.<br> 4. If wanted, the costumer may Choose Places.<br> 5. The system shows the total price to pay.<br> 6. The system redirects the customer to Electronic Payment.<br> 7. The system delivers the electronic tickets to the customer with a unique identifier and QR code. |
| *Alternative flows and exceptions* | 1. [Payment failure] If, in step 6 of the normal flow the payment fails, the system gives the user the possibility to cancel or retry. |