import Pref from '../util/Pref';
import { formBindingData, formProvider } from '@kit.FormKit';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { notificationManager } from '@kit.NotificationKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Observed
export default class Bulb {
  private _pref: Pref;

  constructor(context: Context) {
    this._pref = new Pref(context)
  }

  private _formId = AppStorage.link<string>('formId');
  private _isOpen = AppStorage.link<boolean>('isOpen')

  get isOpen() {
    return this._isOpen.get()
  }

  set isOpen(val: boolean) {
    this._isOpen.set(val)
    this._pref.setIsOpen(val)
    // update widget
    console.log('set isOpen, form id', this._formId.get())
    if (this._formId.get() != '') {
      const data: formDataIsOpen = { 'isOpen': val }
      let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(data);
      formProvider.updateForm(this._formId.get(), formInfo)
    }
  }

  private _brightness = AppStorage.link<number>('brightness');

  get brightness() {
    return this._brightness.get()
  }

  set brightness(val: number) {
    this._brightness.set(val)
    this._pref.setBrightness(val)
  }


  private _r = AppStorage.link<number>('r');

  get r() {
    return this._r.get()
  }

  set r(val: number) {
    this._r.set(val)
  }

  private _g = AppStorage.link<number>('g');

  get g() {
    return this._g.get()
  }

  set g(val: number) {
    this._g.set(val)
  }

  private _b = AppStorage.link<number>('b');

  get b() {
    return this._b.get()
  }

  set b(val: number) {
    this._b.set(val)
  }

  private _morningReminder = AppStorage.link<boolean>('morningReminder');

  get morningReminder() {
    return this._morningReminder.get()
  }

  set morningReminder(val: boolean) {
    if (val) {
      this.setReminder(true)
    } else {
      this.removeReminder(true)
    }

    this._morningReminder.set(val)
  }

  private _nightReminder = AppStorage.link<boolean>('nightReminder');

  get nightReminder() {
    return this._nightReminder.get()
  }

  set nightReminder(val: boolean) {
    if (val) {
      this.setReminder(false)
    } else {
      this.removeReminder(false)
    }

    this._nightReminder.set(val)
  }


  private async setReminder(morning: boolean) {
    let targetReminderAgent: reminderAgentManager.ReminderRequestAlarm = {
      reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM, // The reminder type is alarm.
      hour: morning ? 7 : 23, // Hour portion of the reminder time.
      minute: 0, // Minute portion of the reminder time.
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7], // Days of a week when the reminder repeats..
      actionButton: [// Set the button type and title displayed for the reminder in the notification panel.
        {
          title: 'close',
          type: reminderAgentManager.ActionButtonType.ACTION_BUTTON_TYPE_CLOSE
        },
      ],
      wantAgent: {
        // Information about the target UIAbility that is displayed after the reminder notification is touched.
        pkgName: 'com.hmosdemos.mrbulb',
        abilityName: 'EntryAbility'
      },
      ringDuration: 5, // Ringing duration, in seconds.
      // snoozeTimes: 2, // Number of reminder snooze times.
      // timeInterval: 5 * 60, // Reminder snooze interval, in seconds.
      title: morning ? 'Good morning' : 'Goodnight', // Reminder title.
      content: morning ? 'Do not forget to close the night lamp.' : undefined, // Reminder content.
      // expiredContent: 'this reminder has expired', // Content to be displayed after the reminder expires.
      // snoozeContent: 'remind later', // Content to be displayed when the reminder is snoozed.
      notificationId: 1, // Notification ID used by the reminder. If there are reminders with the same notification ID, the later one will overwrite the earlier one.
      slotType: notificationManager.SlotType.SOCIAL_COMMUNICATION // Type of the slot used by the reminder.
    }

    console.log(targetReminderAgent.hour.toString(), ' ', targetReminderAgent.minute.toString())

    await reminderAgentManager.publishReminder(targetReminderAgent).then((res: number) => {
      let reminderId: number = res; // ID of the published reminder.
      AppStorage.set(morning ? 'morningReminderId' : 'nightReminderId', reminderId)
      console.info('Succeeded in publishing reminder.', reminderId);
    }).catch((err: BusinessError) => {
      console.error(`Failed to publish reminder. Code: ${err.code}, message: ${err.message}`);
    })
  }

  private async removeReminder(morning: boolean) {
    let reminderId: number = AppStorage.get(morning ? 'morningReminderId' : 'nightReminderId') as number;
    // The reminder ID is obtained from the callback after the reminder is published.
    await reminderAgentManager.cancelReminder(reminderId).then(() => {
      console.log('Succeeded in canceling reminder.', reminderId);
    }).catch((err: BusinessError) => {
      console.error(`Failed to cancel reminder. Code: ${err.code}, message: ${err.message}`);
    });
  }
}

interface formDataIsOpen {
  isOpen: boolean
}