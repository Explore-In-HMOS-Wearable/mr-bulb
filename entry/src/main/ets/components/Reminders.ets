import Bulb from '../viewmodel/Bulb';
import { vibrator } from '@kit.SensorServiceKit';

@Component
export default struct Reminders {
  @ObjectLink bulb: Bulb

  build() {
    RelativeContainer() {
      Column() {
        Row() {
          SymbolGlyph($r('sys.symbol.sun_max_fill_1'))
            .fontColor([Color.Yellow])
          Text('Morning')
            .padding({ left: 4 })

          Blank().layoutWeight(1)

          Toggle({
            type: ToggleType.Switch,
            isOn: this.bulb.morningReminder
          })
            .selectedColor(Color.Green)
            .onChange((val) => {
              this.bulb.morningReminder = val
              vibrator.startVibration({ type: 'time', duration: 200 }, { usage: 'physicalFeedback' })
            })
        }
        .backgroundColor($r('app.color.sky_blue'))
        .padding(4)
        .borderRadius(8)

        Row() {
          SymbolGlyph($r('sys.symbol.moon_fill'))
            .fontColor([Color.White])
          Text('Night')
            .padding({ left: 4 })

          Blank().layoutWeight(1)

          Toggle({
            type: ToggleType.Switch,
            isOn: this.bulb.nightReminder
          })
            .selectedColor(Color.Green)
            .onChange((val) => {
              this.bulb.nightReminder = val
              vibrator.startVibration({ type: 'time', duration: 200 }, { usage: 'physicalFeedback' })
            })
        }
        .backgroundColor(Color.Blue)
        .padding(4)
        .borderRadius(8)
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .size({ width: '70%', height: '70%' })
      .alignItems(HorizontalAlign.Start)
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      })
    }
  }
}