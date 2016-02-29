# Reminder_LXZ - CS4720 Web & Mobile Systems Project
An IOS Renminder App by Vivian Liu, Qian Xiong and Yuanyang Zheng.

## Standard Features
- Has feature to add/edit/delete an event according to the project requirement.
- There is a list showing events created.
- Events are ordered by the event date time in ascending order.
- Shows title and due datetime for a tableCell.
- Handles rotation appropriately.
- Show a pop up alert when an event is due while the app is open. Users are able to Dismiss (delete the event) or Postpone (change the reminder day time to one hour later) the event.
- Swipe left on the master page brings up the Delete button.

## Extra Features
- Data Persistence achieved via iOS Core Data.
- Add Push Notification so that a notification will be shown event if the App is not in the foreground.
- Users can shake the device to get back to the master page from the detail page (a Cancel instead of a Save).
- Add input validation for the Save button on the detail page.
- Have two separate event date and reminder date fields for a event. Date selction for those two fields are handled by a single DatePicker in the detail page.
