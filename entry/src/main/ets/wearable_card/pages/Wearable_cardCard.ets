const ls = new LocalStorage()

@Entry(ls)
@Component
struct Wearable_cardCard {
  @LocalStorageProp('isOpen') isOpen: boolean = false

  build() {
    Row() {
      Button() {
        SymbolGlyph($r(this.isOpen ? 'sys.symbol.sun_max_fill_1' : 'sys.symbol.moon_fill'))
          .fontSize(24)
          .fontColor([this.isOpen ? Color.Yellow : Color.White])
      }
      .type(ButtonType.Circle)
      .aspectRatio(1)
      .layoutWeight(1)
      .constraintSize({ maxHeight: '100%' })
      .backgroundColor(this.isOpen ? $r('app.color.sky_blue') : Color.Gray)
      .onClick(() => {
        postCardAction(this, {
          action: 'message',
          params: {
            method: 'openClose',
            isOpen: !this.isOpen
          }
        });

        postCardAction(this, {
          action: 'call',
          abilityName: 'EntryAbility',
          params: {
            method: 'openClose',
            isOpen: !this.isOpen
          }
        });
      })

      Column({ space: 2 }) {
        Row({ space: 2 }) {
          Button() {
            SymbolGlyph($r('sys.symbol.sun_max_fill_1')).fontColor([Color.White])
          }
          .height('100%')
          .layoutWeight(1)
          .borderRadius(4)
          .onClick(() => {
            postCardAction(this, {
              action: 'message',
              params: {
                method: 'setBright',
                brightness: 100
              }
            });

            postCardAction(this, {
              action: 'call',
              abilityName: 'EntryAbility',
              params: {
                method: 'setBright',
                brightness: 100
              }
            });

          })

          Button() {
            SymbolGlyph($r('sys.symbol.lightbulb_max_fill')).fontColor([Color.White])
          }
          .height('100%')
          .layoutWeight(1)
          .borderRadius(4)
          .onClick(() => {
            postCardAction(this, {
              action: 'message',
              params: {
                method: 'setBright',
                brightness: 75
              }
            });

            postCardAction(this, {
              action: 'call',
              abilityName: 'EntryAbility',
              params: {
                method: 'setBright',
                brightness: 75
              }
            });

          })
        }.layoutWeight(1)

        Row({ space: 2 }) {
          Button() {
            SymbolGlyph($r('sys.symbol.lightbulb_fill')).fontColor([Color.White])
          }
          .height('100%')
          .layoutWeight(1)
          .borderRadius(4)
          .onClick(() => {
            postCardAction(this, {
              action: 'message',
              params: {
                method: 'setBright',
                brightness: 50
              }
            });

            postCardAction(this, {
              action: 'call',
              abilityName: 'EntryAbility',
              params: {
                method: 'setBright',
                brightness: 50
              }
            });

          })

          Button() {
            SymbolGlyph($r('sys.symbol.lightbulb')).fontColor([Color.White])
          }
          .height('100%')
          .layoutWeight(1)
          .borderRadius(4)
          .onClick(() => {
            postCardAction(this, {
              action: 'message',
              params: {
                method: 'setBright',
                brightness: 25
              }
            });

            postCardAction(this, {
              action: 'call',
              abilityName: 'EntryAbility',
              params: {
                method: 'setBright',
                brightness: 25
              }
            });

          })
        }.layoutWeight(1)
      }
      .height('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 8 })
    }
    .padding(16)
    .height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.comp_background_primary'))
    .onClick(() => {
      postCardAction(this, {
        action: 'router',
        abilityName: 'EntryAbility',
      });
    })
  }
}