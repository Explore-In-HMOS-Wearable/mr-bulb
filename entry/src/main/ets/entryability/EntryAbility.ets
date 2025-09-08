import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { rpc } from '@kit.IPCKit';
import Pref from '../util/Pref';

const DOMAIN = 0x0000;

interface formData {
  isOpen: boolean,
  brightness: number,
  formId: string
}

class OpenCloseParcelable implements rpc.Parcelable {
  isOpen: boolean

  constructor(isOpen: boolean) {
    this.isOpen = isOpen
  }

  marshalling(messageSequence: rpc.MessageSequence): boolean {
    messageSequence.writeBoolean(this.isOpen)
    return true;
  }

  unmarshalling(messageSequence: rpc.MessageSequence): boolean {
    const dataObj: formData = JSON.parse(messageSequence.readString())
    this.isOpen = dataObj.isOpen
    return true;
  }
}

class BrightnessParcelable implements rpc.Parcelable {
  brightness: number

  constructor(brightness: number) {
    this.brightness = brightness
  }

  marshalling(messageSequence: rpc.MessageSequence): boolean {
    messageSequence.writeDouble(this.brightness)
    return true;
  }

  unmarshalling(messageSequence: rpc.MessageSequence): boolean {
    const dataObj: formData = JSON.parse(messageSequence.readString())
    this.brightness = dataObj.brightness
    return true;
  }
}

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');

    // postCardAction 'call' is caught here
    this.callee.on('openClose', (data: rpc.MessageSequence) => {
      // Obtain all parameters passed in the call event.
      const dataObj: formData = JSON.parse(data.readString())
      console.log('openClose', JSON.stringify(dataObj), dataObj.isOpen);

      AppStorage.set('isOpen', dataObj.isOpen)
      return new OpenCloseParcelable(dataObj.isOpen);
    });

    this.callee.on('setBright', (data: rpc.MessageSequence) => {
      // Obtain all parameters passed in the call event.
      const dataObj: formData = JSON.parse(data.readString())
      console.log('setBright', JSON.stringify(dataObj), dataObj.brightness);

      AppStorage.set('brightness', dataObj.brightness)
      return new BrightnessParcelable(dataObj.brightness);
    });
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
    this.callee.off('openClose');
    this.callee.off('setBright')
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');

      PersistentStorage.persistProp('isOpen', false)
      PersistentStorage.persistProp('brightness', 100)
      PersistentStorage.persistProp('r', 255)
      PersistentStorage.persistProp('g', 255)
      PersistentStorage.persistProp('b', 255)
      PersistentStorage.persistProp('formId', '')
      PersistentStorage.persistProp('morningReminder', false)
      PersistentStorage.persistProp('nightReminder', false)
      PersistentStorage.persistProp('morningReminderId', 0)
      PersistentStorage.persistProp('nightReminderId', 0)

      const pref = new Pref(this.context)

      AppStorage.set('isOpen', pref.getIsOpen())
      AppStorage.set('brightness', pref.getBrightness())
      AppStorage.set('formId', pref.getFormID())
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
    const pref = new Pref(this.context)
    AppStorage.set('formId', pref.getFormID())
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}