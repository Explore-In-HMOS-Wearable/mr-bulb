import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import Pref from '../util/Pref';
import { vibrator } from '@kit.SensorServiceKit';

const TAG: string = 'EntryFormAbility';
const DOMAIN_NUMBER: number = 0xFF00;

export default class EntryFormAbility extends FormExtensionAbility {
  onAddForm(want: Want) {
    hilog.info(DOMAIN_NUMBER, TAG, `onAddForm`);
    if (!want || !want.parameters) {
      hilog.error(0x0000, TAG, `FormAbility onAddForm want or want.parameters is undefined`);
      return formBindingData.createFormBindingData('');
    }

    // Called to return a FormBindingData object.
    let formId: string = want.parameters[formInfo.FormParam.IDENTITY_KEY] as string;

    interface formData { isOpen: boolean }

    const pref: Pref = new Pref(this.context)

    pref.setFormID(formId)
    console.log('set form id', formId)

    const data: formData = { isOpen: pref.getIsOpen() };

    return formBindingData.createFormBindingData(data);
  }

  onCastToNormalForm(formId: string) {
    hilog.info(DOMAIN_NUMBER, TAG, `onCastToNormalForm`);
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onUpdateForm(formId: string) {
    hilog.info(DOMAIN_NUMBER, TAG, `onUpdateForm`);
    // Called to notify the form provider to update a specified form.
  }

  onFormEvent(formId: string, message: string) {
    hilog.info(DOMAIN_NUMBER, TAG, `onFormEvent`);
    // Called when a specified message event defined by the form provider is triggered.

    interface formData {
      method: string,
      isOpen: boolean,
      brightness: number
    }

    // postCardAction 'message' is caught here
    let data: formData = JSON.parse(message);

    const pref: Pref = new Pref(this.context)
    if (data.method === 'openClose') {
      pref.setIsOpen(data.isOpen)
      vibrator.startVibration({ type: 'time', duration: 200 }, { usage: 'physicalFeedback' })
    } else if (data.method === 'setBright') {
      pref.setBrightness(data.brightness)
      vibrator.startVibration({ type: 'time', duration: 200 }, { usage: 'physicalFeedback' })
    }


    let formInfo: formBindingData.FormBindingData = formBindingData.createFormBindingData(data);
    formProvider.updateForm(formId, formInfo).then(() => {
      hilog.info(DOMAIN_NUMBER, TAG, 'FormAbility updateForm success.');
    }).catch((error: BusinessError) => {
      hilog.info(DOMAIN_NUMBER, TAG, `Operation updateForm failed. Cause: ${JSON.stringify(error)}`);
    })
  }

  onRemoveForm(formId: string) {
    hilog.info(DOMAIN_NUMBER, TAG, `onRemoveForm`);
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want) {
    hilog.info(DOMAIN_NUMBER, TAG, `onAcquireFormState`);
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}