import Bulb from '../viewmodel/Bulb';
import { ArcSwiper, ArcSwiperAttribute } from '@kit.ArkUI';
import OpenClose from '../components/OpenClose';
import ColorController from '../components/ColorController';
import { sensor, vibrator } from '@kit.SensorServiceKit';
import Reminders from '../components/Reminders';
import { notificationManager } from '@kit.NotificationKit';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State bulb: Bulb = new Bulb(this.getUIContext().getHostContext()!)

  onPageShow(): void {
    this.bulb = new Bulb(this.getUIContext().getHostContext()!)
  }

  private pos_x_history: number[] = new Array(4).fill(0)
  private neg_x_history: number[] = new Array(4).fill(0)
  private twistHistory: boolean[] = new Array(5).fill(false)

  private _pushToHistory(val: boolean) {
    this.twistHistory.shift()
    this.twistHistory.push(val)
  }

  private _pushToPosX(val: number) {
    this.pos_x_history.shift()
    this.pos_x_history.push(val)
  }

  private getPosX() {
    return this.pos_x_history.reduce((a, b) => a + b, 0)
  }

  private getNegX() {
    return this.neg_x_history.reduce((a, b) => a + b, 0)
  }

  private _pushToNegX(val: number) {
    this.neg_x_history.shift()
    this.neg_x_history.push(val)
  }

  aboutToAppear(): void {
    this.getPermission(this.getUIContext().getHostContext() as common.UIAbilityContext)

    sensor.on(sensor.SensorId.GYROSCOPE, async (res) => {
      if (res.x >= 0) {
        this._pushToPosX(res.x)
        this._pushToNegX(0)
      } else {
        this._pushToPosX(0)
        this._pushToNegX(res.x)
      }

      if (this.getPosX() >= 13 && this.getNegX() <= -13) {
        this.pos_x_history = new Array(4).fill(0)
        this.neg_x_history = new Array(4).fill(0)
        this._pushToHistory(true)
      } else if (this.getPosX() >= 15 || this.getNegX() <= -15) {
        this._pushToHistory(false)
      } else {
        this._pushToHistory(false)
      }

      if (this.twistHistory.filter((val) => val).length >= 2) {
        this.twistHistory = new Array(5).fill(false)
        this.bulb.isOpen = !this.bulb.isOpen
        vibrator.startVibration({ type: 'time', duration: 200 }, { usage: 'physicalFeedback' })
      }
    })
  }

  aboutToDisappear(): void {
    sensor.off(sensor.SensorId.GYROSCOPE)
  }

  build() {
    Stack() {
      ArcSwiper() {
        OpenClose({ bulb: this.bulb })
        ColorController({ bulb: this.bulb })
        Reminders({ bulb: this.bulb })
      }
      .backgroundColor(Color.Black)
      .effectMode(EdgeEffect.None)
    }
  }

  getPermission(context: common.UIAbilityContext) {
    notificationManager.isNotificationEnabled().then((data: boolean) => {
      console.info('isNotificationEnabled success, data: ' + JSON.stringify(data));
      if (!data) {
        notificationManager.requestEnableNotification(context).then(() => {
          console.info(`[ANS] requestEnableNotification success`);
        }).catch((err: BusinessError) => {
          if (1600004 == err.code) {
            console.error(`[ANS] requestEnableNotification refused, code is ${err.code}, message is ${err.message}`);
          } else {
            console.error(`[ANS] requestEnableNotification failed, code is ${err.code}, message is ${err.message}`);
          }
        });
      }
    }).catch((err: BusinessError) => {
      console.error(`isNotificationEnabled fail, code is ${err.code}, message is ${err.message}`);
    });
  }
}