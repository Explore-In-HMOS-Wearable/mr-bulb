import Bulb from '../viewmodel/Bulb';
import { vibrator } from '@kit.SensorServiceKit';

@Component
export default struct ColorController {
  @ObjectLink bulb: Bulb

  build() {
    RelativeContainer() {
      Column() {
        Row() {
          Slider({
            min: 0,
            max: 100,
            value: this.bulb.brightness,
          })
            .selectedColor(Color.White)
            .onChange((val: number) => {
              if (this.bulb.brightness.valueOf() != val.valueOf()) {
                vibrator.startVibration({ type: 'time', duration: 5 }, { usage: 'physicalFeedback' })
                this.bulb.brightness = val
              }
            })
            .layoutWeight(1)
            .onDigitalCrown(() => {
            })
          Text(this.bulb.brightness.toFixed()).fontSize(12)
        }

        Row() {
          Slider({
            min: 0,
            max: 255,
            value: this.bulb.r,
          })
            .selectedColor(Color.Red)
            .onChange(async (val: number) => {
              if (this.bulb.r.valueOf() != val.valueOf()) {
                vibrator.startVibration({ type: 'time', duration: 5 }, { usage: 'physicalFeedback' })
                this.bulb.r = val
              }
            })
            .layoutWeight(1)
          Text(this.bulb.r.toFixed()).fontSize(12)
        }

        Row() {
          Slider({
            min: 0,
            max: 255,
            value: this.bulb.g,
          })
            .selectedColor(Color.Green)
            .onChange((val: number) => {
              if (this.bulb.g.valueOf() != val.valueOf()) {
                vibrator.startVibration({ type: 'time', duration: 5 }, { usage: 'physicalFeedback' })
                this.bulb.g = val
              }
            })
            .layoutWeight(1)
          Text(this.bulb.g.toFixed()).fontSize(12)
        }

        Row() {
          Slider({
            min: 0,
            max: 255,
            value: this.bulb.b,
          })
            .selectedColor(Color.Blue)
            .onChange((val: number) => {
              if (this.bulb.b.valueOf() != val.valueOf()) {
                vibrator.startVibration({ type: 'time', duration: 5 }, { usage: 'physicalFeedback' })
                this.bulb.b = val
              }
            })
            .layoutWeight(1)
          Text(this.bulb.b.toFixed()).fontSize(12)
        }
      }
      .size({ width: '70%', height: '70%' })
      .alignItems(HorizontalAlign.Start)
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      })
    }
  }
}