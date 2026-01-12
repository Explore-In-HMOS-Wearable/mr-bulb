import Bulb from '../viewmodel/Bulb';
import { vibrator } from '@kit.SensorServiceKit';

@Component
export default struct ColorController {
  @ObjectLink bulb: Bulb;

  build() {
    RelativeContainer() {
      Column() {
        Row() {
          Slider({
            min: 0,
            max: 100,
            value: this.bulb.brightness
          })
            .selectedColor(Color.White)
            .onChange((val: number) => {
              if (this.bulb.brightness.valueOf() !== val.valueOf()) {
                vibrator.startVibration({ type: 'time', duration: 5 }, { usage: 'physicalFeedback' });
                this.bulb.brightness = val;
              }
            })
            .layoutWeight(1)
            .onDigitalCrown(() => {
              console.info('');
            });
          Text(this.bulb.brightness.toFixed()).fontSize(12);
        };

        Row() {
          Slider({
            min: 0,
            max: 255,
            value: this.bulb.red
          })
            .selectedColor(Color.Red)
            .onChange(async (val: number) => {
              if (this.bulb.red.valueOf() !== val.valueOf()) {
                vibrator.startVibration({ type: 'time', duration: 5 }, { usage: 'physicalFeedback' });
                this.bulb.red = val;
              }
            })
            .layoutWeight(1);
          Text(this.bulb.red.toFixed()).fontSize(12);
        };

        Row() {
          Slider({
            min: 0,
            max: 255,
            value: this.bulb.green
          })
            .selectedColor(Color.Green)
            .onChange((val: number) => {
              if (this.bulb.green.valueOf() !== val.valueOf()) {
                vibrator.startVibration({ type: 'time', duration: 5 }, { usage: 'physicalFeedback' });
                this.bulb.green = val;
              }
            })
            .layoutWeight(1);
          Text(this.bulb.green.toFixed()).fontSize(12);
        };

        Row() {
          Slider({
            min: 0,
            max: 255,
            value: this.bulb.blue
          })
            .selectedColor(Color.Blue)
            .onChange((val: number) => {
              if (this.bulb.blue.valueOf() !== val.valueOf()) {
                vibrator.startVibration({ type: 'time', duration: 5 }, { usage: 'physicalFeedback' });
                this.bulb.blue = val;
              }
            })
            .layoutWeight(1);
          Text(this.bulb.blue.toFixed()).fontSize(12);
        };
      }
      .size({ width: '70%', height: '70%' })
      .alignItems(HorizontalAlign.Start)
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      });
    };
  }
}