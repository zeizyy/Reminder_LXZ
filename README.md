# Reminder_LXZ - CS4720 Web & Mobile Systems Project
An IOS Renminder App by Vivian Liu, Qian Xiong and Yuanyang Zheng.

## Standard Features
- Has feature to add/edit/delete an event according to the project requirements.
- There is a list showing events created.
- Events are ordered by the event date times in ascending order.
- Shows title and event date time for a tableCell on the master page.
- Handles rotation appropriately.
- Shows a pop up alert when an event is due while the app is in the foreground. Users are able to Dismiss (delete the event) or Postpone (change the reminder day time to one hour later) the event.
- Swiping left on the master page brings up the Delete button.

## Extra Features
- Data Persistence achieved via iOS Core Data.
- Add Push Notification so that a notification will be shown even if the App is not in the foreground.
- Users can shake the device to get back to the master page from the detail page (a Cancel instead of a Save).
- Have two separate event date and reminder date fields for a event. Date selction for those two fields are handled by a single DatePicker in the detail page.
- Add input validations for the Save button on the detail page.
- Implement the detail page using tableView.
