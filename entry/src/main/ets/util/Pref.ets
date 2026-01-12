import { Context } from '@kit.AbilityKit';
import { preferences } from '@kit.ArkData';

export default class Pref {
  constructor(context: Context) {
    const options: preferences.Options = { name: 'user_preferences' };
    this.dataPreferences = preferences.getPreferencesSync(context, options);
  }

  dataPreferences: preferences.Preferences;

  setIsOpen(val: boolean) {
    this.dataPreferences?.putSync('isOpen', val)
    this.dataPreferences?.flushSync()
  }

  getIsOpen() {
    return this.dataPreferences?.getSync('isOpen', false) as boolean
  }

  setBrightness(val: number) {
    this.dataPreferences?.putSync('brightness', val)
    this.dataPreferences?.flushSync()
  }

  getBrightness() {
    return this.dataPreferences?.getSync('brightness', 100) as number
  }

  setFormID(val: string) {
    console.info('setFormID', val);
    this.dataPreferences?.putSync('formId', val)
    this.dataPreferences?.flushSync()
  }

  getFormID() {
    console.info('getFormID', this.dataPreferences?.getSync('formId', '-') as string);
    return this.dataPreferences?.getSync('formId', '') as string
  }
}