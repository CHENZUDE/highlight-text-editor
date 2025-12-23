import { HighlightTextEditor, HighlightTextEditorController } from 'highlighttexteditor'

@Entry
@Component
struct Index {
  @State highlightTags: string[] =
    ['学习', '开发', '设计', '测试', '运维', '生产', '管理', '销售', '服务', '支持', '其他']
  @State selectedTags: string[] = [this.highlightTags[0], this.highlightTags[1]]
  hteController: HighlightTextEditorController = new HighlightTextEditorController()

  aboutToAppear(): void {
    this.hteController.keywords = this.selectedTags
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.highlightTags, (tag: string) => {
          GridItem() {
            Text(tag)
              .height('auto')
              .width('100%')
              .padding({
                top: 8,
                bottom: 8,
                left: 16,
                right: 16
              })
              .textAlign(TextAlign.Center)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .borderRadius(4)
              .borderWidth(2)
              .borderColor(this.selectedTags.includes(tag) ? Color.Red : Color.Gray)
              .onClick(() => {
                if (this.selectedTags.includes(tag)) {
                  this.selectedTags = this.selectedTags.filter((t) => t !== tag)
                } else {
                  this.selectedTags.push(tag)
                }
                this.hteController.keywords = this.selectedTags
                this.hteController.updateTextStyle()
              })
          }
        })
      }.columnsTemplate('1fr 1fr 1fr 1fr 1fr').columnsGap(8).rowsGap(8).maxCount(0)

      HighlightTextEditor({
        hteController: this.hteController,
        config: {
          defaultText: '学习新技术，开发核心功能，优化设计细节',
          defaultOpenInputMethod: true,
          defaultFontColor: Color.Black,
          defaultFontSize: 14,
          highlightTextColor: Color.Red,
          placeholder: '请输入',
        },
        onTextChange: (text: string) => {
          console.debug(text)
        }
      }).margin(16)
    }
    .height('100%')
    .width('100%')
  }
}