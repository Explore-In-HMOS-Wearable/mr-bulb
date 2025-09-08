import Bulb from '../viewmodel/Bulb';
import { vibrator } from '@kit.SensorServiceKit';

@Component
export default struct OpenClose {
  @ObjectLink bulb: Bulb

  build() {
    RelativeContainer() {
      Button() {
        SymbolGlyph($r(this.bulb.isOpen ? 'sys.symbol.sun_max_fill_1' : 'sys.symbol.moon_fill'))
          .fontSize(24)
          .fontColor([this.bulb.isOpen ? Color.Yellow : Color.White])
      }
      .type(ButtonType.Circle)
      .backgroundColor(this.bulb.isOpen ? $r('app.color.sky_blue') : Color.Gray)
      .size({ width: '50%', height: '50%' })
      .onClick(() => {
        this.bulb.isOpen = !this.bulb.isOpen
        vibrator.startVibration({ type: 'time', duration: 200 }, { usage: 'physicalFeedback' })
      })
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      })
    }
    .size({ width: '100%', height: '100%' })
  }
}