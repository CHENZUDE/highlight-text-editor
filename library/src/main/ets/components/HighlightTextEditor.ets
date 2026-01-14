/**
 * 关键字高亮文本编辑器
 */
@ComponentV2
export struct HighlightTextEditor {
  @Param @Require hteController: HighlightTextEditorController
  @Param config: HighlightTextEditorConfig = new HighlightTextEditorConfig()
  @Event onTextChange: (text: string) => void

  aboutToAppear(): void {
    this.hteController.defaultFontColor = this.config.defaultFontColor ?? Color.Black
    this.hteController.defaultFontSize = this.config.defaultFontSize ?? 14
    this.hteController.highlightTextColor = this.config.highlightTextColor ?? Color.Red
    this.hteController.onTextChange = (text) => {
      this.onTextChange(text)
    }
  }

  build() {
    RichEditor({ controller: this.hteController.reController })
      .id(this.hteController.richEditorId)
      .width('100%')
      .height('auto')
      .placeholder(this.config.placeholder, this.config.placeholderStyle)
      .padding(this.config.padding)
      .constraintSize(this.config.constraintSize)
      .barState(BarState.Off)
      .onAppear(() => {
        if (this.config.defaultOpenInputMethod) {
          this.hteController.showKeyboard(this.getUIContext())
        }
      })
      .onReady(() => {
        this.hteController.addText(this.config.defaultText ?? '', 0, false)
      })
      .aboutToIMEInput((value: RichEditorInsertValue) => {
        this.hteController.addText(value.insertValue, value.insertOffset)
        this.hteController.reController.setCaretOffset(value.insertOffset + value.insertValue.length)
        return false
      })
      .aboutToDelete((value: RichEditorDeleteValue) => {
        this.hteController.deleteText(value.length, value.offset)
        this.hteController.reController.setCaretOffset(value.offset)
        return false
      })
  }
}


/**
 * 关键字高亮文本编辑器样式
 */
@ObservedV2
export class HighlightTextEditorConfig {
  /**
   * 默认打开输入法
   */
  defaultOpenInputMethod?: boolean = false
  /**
   * 首次加载的默认文本
   */
  defaultText?: string = ''
  @Trace defaultFontColor?: ResourceColor = Color.Black
  @Trace defaultFontSize?: number = 14
  @Trace highlightTextColor?: ResourceColor = Color.Red
  @Trace placeholder?: string = '请输入'
  @Trace placeholderStyle?: PlaceholderStyle
  @Trace padding?: Padding | Length | LocalizedPadding
  @Trace constraintSize?: ConstraintSizeOptions
}

/**
 * 高亮文本编辑器控制器
 */
@ObservedV2
export class HighlightTextEditorController {
  /**
   * 高亮文本编辑器组件id
   */
  richEditorId = 'HighlightTextRichEditorId'
  /**
   * 富文本编辑器控制器
   */
  reController: RichEditorController = new RichEditorController()
  @Trace private _contentText: string = ''
  /**
   * 默认字体颜色
   */
  @Trace defaultFontColor: ResourceColor = Color.Black
  /**
   * 默认字体大小
   */
  @Trace defaultFontSize: number = 14
  /**
   * 高亮字体颜色
   */
  @Trace highlightTextColor: ResourceColor = Color.Red
  /**
   * 高亮关键词列表
   */
  keywords: string[] = []
  /**
   * 是否正在更新样式，避免循环触发
   */
  private isUpdatingStyle = false;
  /**
   * 文本变化回调
   */
  onTextChange: (text: string) => void = () => {
  }

  /**
   * @param isOnChange 是否触发onTextChange回调
   */
  addText(text: string, offset: number, isOnChange: boolean = true) {
    this._contentText = this._contentText.slice(0, offset) + text + this._contentText.slice(offset)
    if (isOnChange) {
      this.onTextChange(this._contentText)
    }
    this.updateTextStyle()
  }

  deleteText(length: number, offset: number) {
    this._contentText = this._contentText.slice(0, offset) + this._contentText.slice(offset + length)
    this.onTextChange(this._contentText)
    this.updateTextStyle()
  }

  /**
   * 提供给外部调用，无需触发onTextChange回调
   */
  clearText() {
    this._contentText = ''
    this.updateTextStyle()
  }

  updateTextStyle() {
    if (this.isUpdatingStyle) {
      return;
    }
    this.isUpdatingStyle = true;

    try {
      this.keywords = this.keywords.filter(keyword => this._contentText.includes(keyword)).sort((a, b) => {
        return this._contentText.indexOf(a) - this._contentText.indexOf(b);
      });
      this.reController.deleteSpans()
      let tempText = this._contentText
      this.keywords.forEach((keyword) => {
        let index = tempText.indexOf(keyword)
        if (index != -1) {
          this.reController.addTextSpan(tempText.substring(0, index),
            { style: { fontColor: this.defaultFontColor, fontSize: this.defaultFontSize } })
          this.reController.addTextSpan(keyword,
            { style: { fontColor: this.highlightTextColor, fontSize: this.defaultFontSize } })
          tempText = tempText.slice(index + keyword.length, tempText.length)
        }
      })
      this.reController.addTextSpan(tempText,
        { style: { fontColor: this.defaultFontColor, fontSize: this.defaultFontSize } })
    } finally {
      this.isUpdatingStyle = false
    }
  }

  showKeyboard(context: UIContext) {
    try {
      context.getFocusController().requestFocus(this.richEditorId)
    } catch (error) {
      console.error(error)
    }
  }
}